#include beta2.stan
data {
  int<lower = 1> N;
  vector[N] nasalance;
  array[N] int<lower = 1> E;
}
parameters {
  real<lower = 0, upper = 1> mu_contact;
  real<lower = 0, upper = sqrt(mu_contact*(1-mu_contact))> sigma_contact;
  real<lower = 0, upper = 1 > mu_oral;
  real<lower= 0, upper = sqrt(mu_oral*(1-mu_oral))> sigma_oral;
 real<lower = 0, upper = 1> mu_nasalized;
  real<lower = 0, upper = sqrt(mu_nasalized*(1-mu_nasalized))> sigma_nasalized;
}
model {
  // priors for the task component
  target += normal_lpdf(mu_contact | 0.6, 0.2);
  target += normal_lpdf(mu_oral | 0.2, 0.3);
  target += normal_lpdf(mu_nasalized | 0.2, 0.3);
  target += normal_lpdf(sigma_oral | 0, 0.3);
  target += normal_lpdf(sigma_contact | 0, 0.3);
  target += normal_lpdf(sigma_nasalized | 0, 0.3);

  for(n in 1:N){
    if(E[n] == 1)  // contact
      target +=  beta2_lpdf(nasalance[n] | mu_contact, sigma_contact);
     else if(E[n] == 3)  // oral
       target += beta2_lpdf(nasalance[n] | mu_oral, sigma_oral);
    else if(E[n] == 2) //nas
       target += beta2_lpdf(nasalance[n] | mu_nasalized, sigma_nasalized);
  }
}
generated quantities {
  vector[N] log_lik;
  vector[N] nasalance_rep;

  for (n in 1:N) {
    if (E[n] == 1) {  // contact
      log_lik[n] = beta2_lpdf(nasalance[n] | mu_contact, sigma_contact);
      nasalance_rep[n] = beta2_rng(mu_contact, sigma_contact);
    } else if (E[n] == 3) {  // oral
      log_lik[n] = beta2_lpdf(nasalance[n] | mu_oral, sigma_oral);
      nasalance_rep[n] = beta2_rng(mu_oral, sigma_oral);
    } else if (E[n] == 2) {  // nasalized
      log_lik[n] = beta2_lpdf(nasalance[n] | mu_nasalized, sigma_nasalized);
      nasalance_rep[n] = beta2_rng(mu_nasalized, sigma_nasalized);
    }
  }
}
