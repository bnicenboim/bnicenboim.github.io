data {
  int<lower = 0> N_trials;
  int<lower = 0> N_subj;
  int<lower = 0> N_arms;
  int subj[N_trials * N_subj];
  int trial[N_subj, N_trials];
  matrix[N_trials,N_arms] R;
  int response[N_trials * N_subj];
}
transformed data{
  int N_adj = 3;
}
parameters {
  real<lower = 0, upper = 1> alpha;
  real beta_0;
  real beta_1;
  vector<lower = 0>[N_adj] tau_u;
  matrix[N_adj, N_subj] z_u;
  cholesky_factor_corr[N_adj] L_u;
}
transformed parameters{
  matrix[N_subj, N_adj] u = (diag_pre_multiply(tau_u, L_u) * z_u)';

}
model {
  matrix[N_trials * N_subj, N_arms] Q;
  Q[trial[,1],] = rep_matrix(0.5, N_subj, N_arms);
  for(t in 2:N_trials)
    for(a in 1:N_arms)
     Q[trial[,t], a] = Q[trial[, t - 1] , a] + inv_logit(logit(alpha) + u[ ,1]) .* (R[t - 1,a]-Q[trial[,t - 1] ,a]);
  
  target += beta_lpdf(alpha | 1, 1);
  target += normal_lpdf(beta_0 | 2, 5);
  target += normal_lpdf(beta_1 | 0, 1);
  target += normal_lpdf(tau_u | .1, .5)
            - N_adj * normal_lccdf(0 | .1, .5);
  target += lkj_corr_cholesky_lpdf(L_u | 2);
  target += std_normal_lpdf(to_vector(z_u));
  target += bernoulli_logit_lpmf(response | beta_0 + u[subj, 2] + (beta_1+ u[subj, 3]) .* (Q[,2] - Q[,1]));
}

