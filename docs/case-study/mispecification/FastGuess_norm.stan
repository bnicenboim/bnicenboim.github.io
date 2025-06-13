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
  vector[K] beta;
  real<lower = 0> sigma;
  real<upper = alpha> gamma;
  real<lower = 0> sigma2;
  real<lower = 0, upper = 1> p_correct;
  real<lower = 0, upper = 1> p_task;
}
transformed parameters{
  array[N] real log_lik;
  if(only_prior != 1)
    for(n in 1:N)
      log_lik[n] = log_sum_exp(log(p_task) +
                            normal_lpdf(rt[n] | alpha +  X[n] * beta, sigma) +
                            bernoulli_lpmf(acc[n] | p_correct),
                            log1m(p_task) +
                            normal_lpdf(rt[n] | gamma, sigma2) +
                            bernoulli_lpmf(acc[n] | .5));

}
model {
  target += normal_lpdf(alpha | 200, 100);
  target += normal_lpdf(beta | 0, 200);
  target += normal_lpdf(sigma | 100, 100)
    - normal_lccdf(0 | 100, 100);
  target += normal_lpdf(gamma | 200, 100) -
    normal_lcdf(alpha | 200, 100);
  target += normal_lpdf(sigma2 | 100, 100)
    - normal_lccdf(0 | 100, 100);
  target += beta_lpdf(p_correct | 995, 5);
  target += beta_lpdf(p_task | 8, 2);
  if(only_prior != 1)
    target += sum(log_lik);
}
generated quantities {
  array[N] real pred_rt;
  array[N] int pred_response;
  for(n in 1:N){
    int ontask = bernoulli_rng(p_task);
    if(ontask == 1){
      pred_response[n] = bernoulli_rng(p_correct) == 1 ? 1 : 2;
      pred_rt[n] = normal_rng(alpha + X[n] * beta, sigma);
    } else {
      pred_response[n] = bernoulli_rng(.5) == 1 ? 1 : 2;
      pred_rt[n] = normal_rng(gamma, sigma2);

    }
  }
}
