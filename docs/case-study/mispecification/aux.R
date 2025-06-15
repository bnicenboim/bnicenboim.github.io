bf_compare <- function(l){
  mname <- names(l)
  if(is.null(mname)) mname <- paste0("m",seq_along(l), sep="")
  out <- map_dbl(l,~ .x$logml)
  names(out) <- mname
  out <- sort(-out)
  model_names <- names(out)
  out <- -out[1] + out[1:length(out)]
  print(matrix( c(signif(round(exp(out),2), 3), round(out,1)), ncol = 2,
         dimnames = list(names(out), c("BF", "logBF"))))
  message(paste0("# Reference is ", names(out)[1], "."))
}


qpf <- function(df_grouped, quantiles = c(.1, .3, .5, .7, .9)) {
  df_grouped %>% reframe(
    rt_q = list(c(quantile(rt[acc == 0], quantiles),
             quantile(rt[acc == 1], quantiles))),
    p = list(c(rep(mean(acc == 0), length(quantiles)),
          rep(mean(acc == 1), length(quantiles)))),
    q = list(rep(quantiles, 2)),
    response = list(c(rep("incorrect", length(quantiles)),
                 rep("correct", length(quantiles))))) %>%
    # Since the summary contains a list in each column,
    # we unnest it to have the following number of rows:
    # number of quantiles x groups x 2 (incorrect, correct)
    tidyr::unnest(cols = c(rt_q, p, q, response))
}
do_qpf <- function(fit, dsim, cond){
  ## df_rt <- fit_lnrace$draws("pred_rt") %>%
  df_rt <- extract(fit, pars = "pred_rt") %>%
    ## df_rt <- extract(fit_lnrace, pars = "pred_rt") %>%

  # Convert a matrix of 200 x 24000 (iter x N obs)
  # into a data.frame where each column is
  # V1,...,V24000:
  as.data.frame() %>%
  ## select(-.chain, -.iteration, -.draw) %>%
  # Add a column which identifies each iter as a simulation:
  mutate(sim = 1:n()) %>%
  # Pivot the data frame so that it has length 200 * 24000.
  # Each row indicates:
  # - sim: from which simulation the observation is coming
  # - obs_id: identifies the 24000 observations
  # - rt_pred: simulated RT
  # Since each observation is in a column starting with V
  # `names_prefix` removes the "V"
  pivot_longer(cols = -sim,
               names_to = "obs_id",
               names_prefix = "V",
               values_to = "pred_rt") %>%
  # Make sure that obs_id is a number (and not a
  # number represented as a character):
  mutate(obs_id = stringr::str_extract(obs_id, pattern ="\\d+") %>%
           as.numeric()
         )
  df_rt

  df_nchoice <- extract(fit, pars = "pred_response") %>%
    ## df_nchoice <- extract(fit_lnrace, pars = "pred_response") %>%
    ## as_draws_df() %>%
    as.data.frame() %>%
    ## select(-.chain, -.iteration, -.draw) %>%
    mutate(sim = 1:n()) %>%
    pivot_longer(cols = -sim,
                 names_to = "obs_id",
                 names_prefix = "V",
                 values_to = "pred_response") %>%
    mutate(obs_id = stringr::str_extract(obs_id, pattern ="\\d+") %>% as.numeric())
  df_nchoice


  dsim <- dsim %>%
    mutate(obs_id = 1:n())
  dsim_pred <- left_join(df_rt, df_nchoice) %>%
    left_join(select(dsim, -rt, -response)) %>%
    rename(rt = pred_rt, response = pred_response) %>%
    bind_rows(dsim) %>%
    mutate(acc = ifelse(response==1,1,0))
  dsim_pred

  dsim_qpf <- dsim_pred  %>%
    # Subset only words
    # Group by condition  and subject
    group_by({{cond}}, sim) %>%
    # Apply the quantile probability function
    qpf() %>%
    # Get averages of all the quantities
    summarize(rt_q = mean(rt_q),
              p = mean(p), .by = c({{cond}}, sim, q, response) )

  ggplot(dsim_qpf %>% filter(sim <200 ), aes(x = p, y = rt_q)) +
    geom_point(shape = 4, alpha = 0.1) +
    geom_line(aes(group = interaction(q, response, sim)),
              alpha = 0.1,
              color = "grey") +
    ylab("log-transformed RT quantiles (ms) ") +
    xlab("Response proportion")  +
    geom_point(data = dsim_qpf %>% filter(is.na(sim)),
               shape = 4) +
    geom_line(data = dsim_qpf %>% filter(is.na(sim)),
              aes(group = interaction(q, response))) +
    coord_trans(y = "log")
}

print_model <- function(x) {
  x <- as_draws(x)
  pattern <- "^(?!pred_|log_lik|lp__).+"
  pars <- grep(pattern, variables(x), value = TRUE, perl = TRUE)
  subset_draws(x, variable = pars) |> summarise_draws(mean, ~quantile(.x, c(0.025,.975)), rhat, ess_bulk, ess_tail, .num_args = list(sigfig = 2, notation = "dec"))

}

saveread <- function(x, filename = paste0(x,".RDS")) {
  # Check if the file exists
  if (!file.exists(filename)) {
    # If the file does not exist, save the object
    saveRDS(object = get(x, envir = .GlobalEnv), file = filename)
    message("Object saved to ", filename, "\n")
  } else {
    # If the file exists, read the object from the file
    object <- readRDS(file = filename)
    assign(x, object, envir = .GlobalEnv)
    message("Object read from ", filename, "\n")
  }
}


violin_plot <- function(data, fit, N_sim = 20) {

  data <- data |>
    ungroup() |>
    mutate(id = 1:n())
  data_pred <- tidytable(rt = extract(fit,
                                      pars = "pred_rt")$pred_rt[1:N_sim,] %>%
                                                       t() %>%
                                                       c(),
                         response = extract(fit,
                                            pars = "pred_response")$pred_response[1:N_sim,] %>%
                                                                   t() %>%
                                                                   c(),
                         id = rep(1:nrow(data), N_sim),
                         sim = rep(1:N_sim, each = nrow(data)),
                         model = "FG") |>
    left_join(select(data, -rt, -response, -resp)) |> mutate(resp = ifelse(response == 1, "correct" ,"incorrect"))



  ggplot(data_pred, aes(x = rt, y = resp,  group = interaction(resp,sim))) +
    geom_violin(position = "identity", fill =NA, draw_quantiles = c(.025,.5,.975), scale = "count", alpha = .5, color = "gray") +
    ## geom_jitter(alpha = .2, width = 0, height = .25) +
    facet_grid(emphasis ~ difficulty) +
    xlab("Response time [ms]") +
    ylab("Accuracy")+
    geom_violin(data = data, aes(x=rt, y=resp), draw_quantiles = c(.025,.5,.975), scale = "count", alpha = 1, inherit.aes = FALSE, fill = NA) +
    coord_cartesian(xlim = c(0, 800))

}



load_or_fit <- function(path, fit_expr) {
  if (file.exists(path)) {
    readRDS(path)
  } else {
    fit <- eval(substitute(fit_expr))
    saveRDS(fit, path)
    fit
  }
}

loo_compare <- function(...) {
  lc <- loo::loo_compare(...)
  n_se <- lc[,1]/lc[,2]
  cbind(lc[,1:2],n_se)
}
