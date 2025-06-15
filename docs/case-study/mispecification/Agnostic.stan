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
}
transformed parameters{
  array[N] real log_lik;
  if(only_prior != 1)
    for(n in 1:N){
      log_lik[n] = normal_lpdf(rt[n] | alpha + X[n] * beta[1], sigma) +
        bernoulli_logit_lpmf(acc[n] | logit(prob) + X[n] * beta[2]);
    }
}
model {
  target += normal_lpdf(alpha | 500, 50);
  target += beta_lpdf(prob | 900, 100);
  
  target += normal_lpdf(beta[1] | 0, 50);
  target += normal_lpdf(beta[2] | 0, .5);
  target += normal_lpdf(sigma | 100, 100)
    - normal_lccdf(0 | 100, 100);
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
    
    pred_rt[n] = normal_rng(alpha + X[n] * beta[1], sigma);
    }
}
