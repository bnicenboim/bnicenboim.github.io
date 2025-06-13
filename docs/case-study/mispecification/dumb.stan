data {
  int<lower = 1> N;
  vector[N] cond;
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
  array[2] real beta;
  real<lower = 0> sigma;
  real<lower = 0, upper = min(rt)> T_nd;
}
transformed parameters{
  array[N] real log_lik;
  if(only_prior != 1)
    for(n in 1:N){
      log_lik[n] = lognormal_lpdf(rt[n] - T_nd| alpha + beta[1] * cond[n], sigma) +
        bernoulli_logit_lpmf(acc[n] | logit(prob) + beta[2] * cond[n]);
    }
}
model {
  target += normal_lpdf(alpha | 6, 1);
  target += beta_lpdf(prob | 80, 10);
  
  target += normal_lpdf(beta | 0, .5);
  target += normal_lpdf(sigma | .5, .2)
    - normal_lccdf(0 | .5, .2);
  target += normal_lpdf(T_nd | 150, 100)
    - log_diff_exp(normal_lcdf(min(rt) | 150, 100),
                   normal_lcdf(0 | 150, 100));
  if(only_prior!=1)
    target += sum(log_lik);
}
generated quantities {
  array[N] real pred_rt;
  array[N] int pred_response;
  for(n in 1:N){
    int pacc = bernoulli_logit_rng(logit(prob) + beta[2] * cond[n]);
    if(pacc==1)
      pred_response[n] = 1;
    else
      pred_response[n] = 2;
    
    pred_rt[n] = lognormal_rng(alpha + beta[1] * cond[n], sigma) + T_nd;
    }
}
