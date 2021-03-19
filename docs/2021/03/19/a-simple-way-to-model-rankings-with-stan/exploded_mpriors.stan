functions {
 real exploded_lpmf(int[] x, vector Theta){
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
  int N_ranking; //total times the choices were ranked
  int N_ranked; //total choices ranked
  int N_options; //total options
  int res[N_ranking, N_ranked];
  real alpha;
}
parameters {
  simplex[N_options] Theta;
}
model {
  target += dirichlet_lpdf(Theta| rep_vector(alpha, N_options));
  for(r in 1:N_ranking){
    target += exploded_lpmf(res[r]|Theta);
  }
}
