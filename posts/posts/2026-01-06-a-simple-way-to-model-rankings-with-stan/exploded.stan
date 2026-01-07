functions {
  real exploded_lpmf(array[] int x, vector Theta){
    real out = 0;
    vector[num_elements(Theta)] thetar = Theta;
    for(pos in x){
      out += log(thetar[pos]) - log(sum(thetar));
      thetar[pos] = 0;
    }
    return(out);
  }
}
data{
  int N_ranking;
  int N_ranked;
  int N_options;
  array[N_ranking, N_ranked] int res;
}
parameters {
  simplex[N_options] Theta;
}
model {
  target += dirichlet_lpdf(Theta | rep_vector(1, N_options));
  for(r in 1:N_ranking){
    target += exploded_lpmf(res[r] | Theta);
  }
}
