functions {
  real beta2_lpdf(real x, real mu, real sigma) {
    // Check constraints
    if (mu <= 0 || mu >= 1)
      reject("mu must be between 0 and 1, but is ", mu);
    real variance = square(sigma);
    real max_variance = mu * (1 - mu);
    if (variance >= max_variance)
      reject("variance must be smaller than mu * (1 - mu). Got variance = ", variance, 
             " and mu * (1 - mu) = ", max_variance);

    // Compute alpha and beta
    real alpha = ((1 - mu) / variance - 1 / mu) * square(mu);
    real beta = alpha * (1 / mu - 1);
    return beta_lpdf(x | alpha, beta);
  }
 real beta2_rng(real mu, real sigma) {
    // Check constraints
    if (mu <= 0 || mu >= 1)
      reject("mu must be between 0 and 1, but is ", mu);
    real variance = square(sigma);
    real max_variance = mu * (1 - mu);
    if (variance >= max_variance)
      reject("variance must be smaller than mu * (1 - mu). Got variance = ", variance, 
             " and mu * (1 - mu) = ", max_variance);

    // Compute alpha and beta
    real alpha = ((1 - mu) / variance - 1 / mu) * square(mu);
    real beta = alpha * (1 / mu - 1);
    
    return beta_rng(alpha, beta);
  }
}
