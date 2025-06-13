#include beta2.stan
data {
  int<lower = 1> N;
  vector[N] nasalance;
  array[N] int<lower = 1> E;
  array[N] int<lower = 1> speaker;
  int<lower = 1> N_speaker;
}
parameters {
  real<lower = 0, upper = 1> mu_contact;
  real<lower = 0, upper = sqrt(mu_contact*(1-mu_contact))> sigma_contact;
  real<lower = 0, upper = 1 > mu_oral;
  real<lower= 0, upper = sqrt(mu_oral*(1-mu_oral))> sigma_oral;

  // now it's log odds
  real<lower = 0, upper = 1> av_prob_nas;

  real<lower = 0>  tau_u;
  vector[N_speaker] z_u;
}
transformed parameters {
  vector[N_speaker] u;
  u = tau_u * z_u;
}
model {
  // priors for the task component
  target += normal_lpdf(mu_contact | 0.6, 0.2);
  target += normal_lpdf(mu_oral | 0.2, 0.3);
  target += normal_lpdf(sigma_oral | 0, 0.3);
  target += normal_lpdf(sigma_contact | 0, 0.3);

  target += std_normal_lpdf(z_u);
  target += normal_lpdf(tau_u | 0, 2);
  
  target += beta_lpdf(av_prob_nas | 3, 10);

  for(n in 1:N){
    if(E[n] == 1)  // contact
      target +=  beta2_lpdf(nasalance[n] | mu_contact, sigma_contact);
     else if(E[n] == 3)  // oral
       target += beta2_lpdf(nasalance[n] | mu_oral, sigma_oral);
    else if(E[n] == 2) { //nas
       real logodds_nas = logit(av_prob_nas) + u[speaker[n]];
       target += log_sum_exp(log_inv_logit(logodds_nas) +
                  beta2_lpdf(nasalance[n] | mu_contact, sigma_contact),
                  log1m_inv_logit(logodds_nas)+
                  beta2_lpdf(nasalance[n] | mu_oral, sigma_oral));
       }
  }
}
generated quantities {
  vector[N] log_lik;
  vector[N] nasalance_rep;
  vector[N_speaker] prob_nas_speaker = inv_logit(logit(av_prob_nas) + u);
  
  for (n in 1:N) {
    if (E[n] == 1) {  // contact
      log_lik[n] = beta2_lpdf(nasalance[n] | mu_contact, sigma_contact);
      nasalance_rep[n] = beta2_rng(mu_contact, sigma_contact);
    } else if (E[n] == 3) {  // oral
      log_lik[n] = beta2_lpdf(nasalance[n] | mu_oral, sigma_oral);
      nasalance_rep[n] = beta2_rng(mu_oral, sigma_oral);
    } else if (E[n] == 2) { // nas
      real logodds_nas = logit(av_prob_nas) + u[speaker[n]];
      real theta = inv_logit(logodds_nas);
      log_lik[n] = log_sum_exp(
        log(theta) + beta2_lpdf(nasalance[n] | mu_contact, sigma_contact),
        log1m(theta) + beta2_lpdf(nasalance[n] | mu_oral, sigma_oral)
      );
      if (bernoulli_rng(theta) == 1)
        nasalance_rep[n] = beta2_rng(mu_contact, sigma_contact);
      else
        nasalance_rep[n] = beta2_rng(mu_oral, sigma_oral);
    }
  }
}
