#' Create a New Blog Post
#'
#' Creates a new blog post directory with a templated index.qmd file in the
#' blog/posts folder. The folder name follows the pattern YYYY-MM-DD-slug.
#'
#' @param title Character string. The title of the blog post.
#' @param author Character string. Author name. Defaults to "Bruno Nicenboim".
#' @param categories Character vector. Categories/tags for the post. Default is NULL.
#' @param draft Logical. Whether to mark the post as a draft. Default is FALSE.
#' @param date Date or character string. Publication date. Defaults to today's date.
#' @param description Character string. Short description of the post. Default is empty.
#' @param open Logical. Whether to open the file in RStudio after creation. Default is TRUE.
#'
#' @return Invisibly returns the path to the created index.qmd file.
#'
#' @examples
#' \dontrun{
#' # Create a simple post
#' new_post("My First Analysis")
#'
#' # Create a post with categories
#' new_post("Bayesian Regression in Stan",
#'          categories = c("R", "Stan", "Bayesian"))
#'
#' # Create a draft post
#' new_post("Work in Progress",
#'          categories = c("R", "Statistics"),
#'          draft = TRUE)
#'
#' # Create a post with a specific date
#' new_post("Historical Analysis",
#'          date = "2024-12-01",
#'          categories = c("R"))
#'
#' # Create a post with a custom description
#' new_post("Advanced Stan Techniques",
#'          description = "Exploring reparameterization and vectorization",
#'          categories = c("Stan", "Bayesian", "Tutorial"))
#' }
#'
#' @export
new_post <- function(title,
                     author = "Bruno Nicenboim",
                     categories = NULL,
                     draft = FALSE,
                     date = Sys.Date(),
                     description = "",
                     open = TRUE) {
  
  # Validate inputs
  if (!is.character(title) || length(title) != 1 || nchar(title) == 0) {
    stop("title must be a non-empty character string")
  }
  
  # Create slug from title
  slug <- tolower(title)
  slug <- gsub("[^a-z0-9]+", "-", slug)
  slug <- gsub("^-|-$", "", slug)
  
  # Handle date
  if (is.character(date)) {
    date <- as.Date(date)
  }
  date_string <- as.character(date)
  
  # Create folder name: YYYY-MM-DD-slug
  folder_name <- paste0(date_string, "-", slug)
  folder_path <- file.path("blog", "posts", folder_name)
  
  # Check if folder already exists
  if (dir.exists(folder_path)) {
    stop("Post folder already exists: ", folder_path)
  }
  
  # Create directory
  dir.create(folder_path, recursive = TRUE, showWarnings = FALSE)
  
  # Build YAML header
  yaml_lines <- c(
    "---",
    paste0('title: "', title, '"')
  )
  
  if (nchar(description) > 0) {
    yaml_lines <- c(yaml_lines, paste0('description: "', description, '"'))
  } else {
    yaml_lines <- c(yaml_lines, 'description: ""')
  }
  
  yaml_lines <- c(yaml_lines, paste0('author: "', author, '"'))
  yaml_lines <- c(yaml_lines, paste0('date: "', date_string, '"'))
  
  if (!is.null(categories) && length(categories) > 0) {
    # Properly format categories
    cats <- paste0('"', categories, '"', collapse = ", ")
    yaml_lines <- c(yaml_lines, paste0('categories: [', cats, ']'))
  }
  
  if (draft) {
    yaml_lines <- c(yaml_lines, 'draft: true')
  }
  
  yaml_lines <- c(yaml_lines, "---", "")
  
  # Add template content
  content <- c(
    yaml_lines,
    "## Introduction",
    "",
    "Write your introduction here.",
    "",
    "```{r}",
    "#| label: setup",
    "#| message: false",
    "#| warning: false",
    "",
    "library(tidytable)",
    "# library(rstan)",
    "# library(cmdstanr)",
    "```",
    "",
    "## Analysis",
    "",
    "Your analysis goes here.",
    "",
    "```{r}",
    "#| label: analysis",
    "",
    "# Your R code",
    "```",
    "",
    "## Stan Model",
    "",
    "```{stan}",
    "#| label: model",
    "#| output.var: model",
    "#| eval: false",
    "",
    "// Your Stan model",
    "data {",
    "  int<lower=0> N;",
    "}",
    "parameters {",
    "  real theta;",
    "}",
    "model {",
    "  theta ~ normal(0, 1);",
    "}",
    "```",
    "",
    "## Results",
    "",
    "Present your results here.",
    "",
    "## Conclusion",
    "",
    "Summarize your findings.",
    ""
  )
  
  # Write to index.qmd
  file_path <- file.path(folder_path, "index.qmd")
  writeLines(content, file_path)
  
  message("✓ Created new post at: ", file_path)
  
  # Open in RStudio if available and requested
  if (open && rstudioapi::isAvailable()) {
    rstudioapi::navigateToFile(file_path)
  }
  
  invisible(file_path)
}