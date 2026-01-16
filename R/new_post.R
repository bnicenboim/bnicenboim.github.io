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
#' @param citable Logical. Whether to add citation info. (Adding Citable as a category has the same effect).
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
#'          categories = c("R", "Stan", "Bayesian"),
#'          citable = TRUE)
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
                     citable = FALSE,
                     open = TRUE) {
  
  # Validate inputs
  if (!is.character(title) || length(title) != 1 || nchar(title) == 0) {
    stop("title must be a non-empty character string")
  }
  citation_info <- citable || (!is.null(categories) && "Citable" %in% categories)
  
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
  folder_path <- file.path("posts", "posts", folder_name)
  
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
  yaml_lines <- c(yaml_lines, paste0('license: "MIT"'))
  
  if (!is.null(categories) && length(categories) > 0) {
    # Properly format categories
    cats <- paste0('"', categories, '"', collapse = ", ")
    yaml_lines <- c(yaml_lines, paste0('categories: [', cats, ']'))
  }
  
  if (draft) {
    yaml_lines <- c(yaml_lines, 'draft: true')
  }
  if (citation_info) {
    yaml_lines <- c(yaml_lines, paste0('doi: ""'))
    yaml_lines <- c(yaml_lines, paste0('bibliography: references.bib'))
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
  
  # Add dynamic citation block if citable or has "Citable" category
  if (citation_info) {
    content <- c(
      content,
      "",
      "## How to cite this post",
      "",
      "```{r}",
      "#| echo: false",
      "#| results: asis",
      "",
      "# Read YAML metadata from this file",
      "yaml_data <- rmarkdown::yaml_front_matter(knitr::current_input())",
      "",
      "# Create slug from title",
      "slug <- tolower(yaml_data$title)",
      "slug <- gsub(\"[^a-z0-9]+\", \"-\", slug)",
      "slug <- gsub(\"^-|-$\", \"\", slug)",
      "",
      "# Extract year and month",
      "post_date <- as.Date(yaml_data$date)",
      "year <- format(post_date, \"%Y\")",
      "month <- format(post_date, \"%B\")",
      "full_date <- format(post_date, \"%Y, %B %d\")",
      "",
      "# Build URL",
      "post_url <- paste0(",
      "  \"https://bruno.nicenboim.me/posts/posts/\",",
      "  yaml_data$date, \"-\", slug, \"/\"",
      ")",
      "",
      "# BibTeX entry",
      "bibtex_key <- paste0(\"nicenboim\", year, gsub(\"-\", \"\", slug))",
      "",
      "cat(\"::: {.callout-tip collapse=\\\"true\\\"}\\n\")",
      "cat(\"## Citation\\n\\n\")",
      "cat(\"**BibTeX:**\\n\\n\")",
      "cat(\"```bibtex\\n\")",
      "cat(paste0(\"@misc{\", bibtex_key, \",\\n\"))",
      "cat(\"  author = {Nicenboim, Bruno},\\n\")",
      "cat(paste0(\"  title = {\", yaml_data$title, \"},\\n\"))",
      "cat(paste0(\"  year = {\", year, \"},\\n\"))",
      "cat(paste0(\"  month = {\", month, \"},\\n\"))",
      "cat(paste0(\"  url = {\", post_url, \"}\"))",
      "if (!is.null(yaml_data$doi) && nchar(yaml_data$doi) > 0) {",
      "  cat(\",\\n\")",
      "  cat(paste0(\"  doi = {\", yaml_data$doi, \"}\"))",
      "}",
      "cat(\"\\n}\\n\")",
      "cat(\"```\\n\\n\")",
      "",
      "# APA citation",
      "cat(\"**APA:**\\n\\n\")",
      "apa <- paste0(",
      "  \"Nicenboim, B. (\", full_date, \"). *\",",
      "  yaml_data$title, \"*. \"",
      ")",
      "if (!is.null(yaml_data$doi) && nchar(yaml_data$doi) > 0) {",
      "  apa <- paste0(apa, \"https://doi.org/\", yaml_data$doi)",
      "} else {",
      "  apa <- paste0(apa, post_url)",
      "}",
      "cat(apa)",
      "cat(\"\\n\\n\")",
      "cat(\":::\")",
      "```",
      "",
      "## Session info",
      "",
      "```{r}",
      "#| echo: false",
      "sessionInfo()",
      "```",
      "",
      "## References",
      "",
      "::: {#refs}",
      ":::",
      ""
    )
    
    # Create empty references.bib file
    bib_path <- file.path(folder_path, "references.bib")
    writeLines("", bib_path)
    message("✓ Created bibliography file: ", bib_path)
  }
  
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