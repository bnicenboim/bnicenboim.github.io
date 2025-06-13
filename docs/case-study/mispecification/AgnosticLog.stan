data {
  int<lower = 1> N;
  int<lower = 1> K;
  matrix[N, K] X;
  vector[N] rt; //ms
  array[N] int response;
  int only_prior;
}
transformed data {
  array[N] int acc;
  for(n in 1:N)
    if(response[n] == 1)
      acc[n] = 1;
    else
      acc[n] = 0;
}
parameters {
  real alpha;
  real<lower=0, upper=1> prob;
  array[2] vector[K] beta;
  real<lower = 0> sigma;
  real<lower = 0, upper = min(rt)> T_shift;
}
transformed parameters{
  array[N] real log_lik;
  if(only_prior != 1)
    for(n in 1:N){
      log_lik[n] = lognormal_lpdf(rt[n] - T_shift | alpha + X[n] * beta[1], sigma) +
        bernoulli_logit_lpmf(acc[n] | logit(prob) + X[n] * beta[2]);
    }
}
model {
  target += beta_lpdf(prob | 1, 1);
  target += normal_lpdf(alpha | 0, 100);
  for(k in 1:K) target += normal_lpdf(beta[k] | 0, 10);
  target += normal_lpdf(sigma | 0, 100)
    - normal_lccdf(0 | 0, 100);
  target += normal_lpdf(T_shift | 150, 100)
    - log_diff_exp(normal_lcdf(min(rt) | 150, 100),
                   normal_lcdf(0 | 150, 100));
if(only_prior!=1)
    target += sum(log_lik);
}
generated quantities {
  array[N] real pred_rt;
  array[N] int pred_response;
  for(n in 1:N){
    int pacc = bernoulli_logit_rng(logit(prob) + X[n] * beta[2]);
    if(pacc==1)
      pred_response[n] = 1;
    else
      pred_response[n] = 2;
    
    pred_rt[n] = lognormal_rng(alpha + X[n] * beta[1], sigma) + T_shift;
    }
}
