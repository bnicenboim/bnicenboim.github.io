data {
  int<lower=0> N_trials;
  int action[N_trials];
  int N_arms;
  matrix[N_trials,N_arms] R;
}
transformed data {
  int response[N_trials];
  for(n in 1:N_trials)
    response[n] = action[n] - 1;
}
parameters {
  real<lower = 0, upper = 1> alpha;
  real beta_0;
  real beta_1;
}
transformed parameters{
  matrix[N_trials + 1, N_arms] Q;
  // everything is initialized as 0.5
  Q = rep_matrix(0.5, N_trials + 1, N_arms);
  for(t in 1:N_trials)
    // everytime the update is propagated into the future
    Q[(t + 1):(N_trials + 1), action[t]] =
       rep_vector(
                  Q[t, action[t]] + alpha * (R[t, action[t]] - Q[t,action[t]]),
                  N_trials - t + 1);
}
model {
  target += beta_lpdf(alpha | 1, 1);
  target += normal_lpdf(beta_0 | 2, 5);
  target += normal_lpdf(beta_1 | 0, 1);
  target += bernoulli_logit_lpmf(response | beta_0 + beta_1 * (Q[1:N_trials, 2] - Q[1:N_trials, 1]));
}

