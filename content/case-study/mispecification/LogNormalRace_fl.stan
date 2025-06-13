functions{
  real lognormalrace2_lpdf(real rt, int response,
                           real T_nd,
                           array[] real mu,
                           array[] real sigma){
    real T = rt - T_nd;
    real lp = 0;
    if(response==1)
      lp += lognormal_lpdf(T | mu[1], sigma[1]) +
        lognormal_lccdf(T | mu[2], sigma[2]);
    else
      lp += lognormal_lpdf(T | mu[2], sigma[1]) +
        lognormal_lccdf(T | mu[1], sigma[2]);
    return lp;
  }
  array[] real  lognormalrace2_rng(real T_nd,
                          array[] real mu,
                          array[] real sigma){
    real rt1 = lognormal_rng(mu[1], sigma[1]);
    real rt2 = lognormal_rng(mu[2], sigma[2]);
    array[2] real out;
    if(rt1 < rt2)
      out = {rt1 + T_nd, 1.0};
    else
      out = {rt2 + T_nd, 2.0};
    return out;
      }
}
data {
  int<lower = 1> N;
  int<lower = 1> K;
  matrix[N, K] X;
  vector[N] rt; //ms
  array[N] int response;
  int only_prior;
}
parameters {
  array[4] real alpha;
  array[4] vector[K] beta;
  real<lower = 0, upper = min(rt)> T_nd;
}
transformed parameters{
  array[N] real log_lik;
  if(only_prior != 1)
    for(n in 1:N){
      log_lik[n] = lognormalrace2_lpdf(rt[n]| response[n],
                                       T_nd,
                                        {alpha[1] + X[n] * beta[1],
                                         alpha[2] + X[n] * beta[2]},
                                       {exp(alpha[3] + X[n] * beta[3]),
                                        exp(alpha[4] + X[n] * beta[4])});
    }
}
model {
  target += normal_lpdf(alpha[1:2] | 5.2, 1);
  target += normal_lpdf(alpha[3:4] | log(0.5), 1);
  for(k in 1:K) target += normal_lpdf(beta[k] | 0, .2);
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
    array[2] real out;
    out = lognormalrace2_rng(T_nd,
                             {alpha[1] + X[n] * beta[1],
                              alpha[2] + X[n] * beta[2]},
                             {exp(alpha[3] + X[n] * beta[3]),
                              exp(alpha[4] + X[n] * beta[4])});
    pred_rt[n] = out[1];
    pred_response[n] = to_int(out[2]);
    }
}
