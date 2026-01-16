#' Create an archive bundle of a blog post for Zenodo
#'
#' Creates a ZIP archive containing a rendered self-contained HTML version plus source files.
#' If no post_path is provided, uses the currently open file in RStudio.
#'
#' @param post_path Path to the post directory. If NULL, uses current file.
#' @param include_source Include source files (.qmd, .bib, .stan). Default TRUE.
#' @param output_dir Directory to save the archive. If NULL, saves in post directory.
#' @export
archive_post <- function(post_path = NULL, include_source = TRUE, output_dir = NULL) {
  
  # If no path provided, try to get current file from RStudio
  if (is.null(post_path)) {
    if (rstudioapi::isAvailable()) {
      current_file <- rstudioapi::getSourceEditorContext()$path
      if (nchar(current_file) == 0) {
        stop("No file is currently open in RStudio. Please specify post_path.")
      }
      post_path <- dirname(current_file)
      message("Using current file's directory: ", post_path)
    } else {
      stop("Not running in RStudio and no post_path provided. Please specify post_path.")
    }
  }
  
  if (!dir.exists(post_path)) {
    stop("Post directory not found: ", post_path)
  }
  
  # Set output directory to post path if not specified
  if (is.null(output_dir)) {
    output_dir <- post_path
  }
  
  qmd_file <- file.path(post_path, "index.qmd")
  if (!file.exists(qmd_file)) {
    stop("index.qmd not found in: ", post_path)
  }
  
  # Read YAML for metadata
  yaml_data <- rmarkdown::yaml_front_matter(qmd_file)
  slug <- tolower(yaml_data$title)
  slug <- gsub("[^a-z0-9]+", "-", slug)
  slug <- gsub("^-|-$", "", slug)
  
  archive_name <- paste0(yaml_data$date, "-", slug, "-archive.zip")
  archive_path <- file.path(output_dir, archive_name)
  
  # Create temporary directory for bundle
  temp_dir <- tempfile()
  dir.create(temp_dir)
  bundle_dir <- file.path(temp_dir, paste0(yaml_data$date, "-", slug))
  dir.create(bundle_dir)
  
  # Ensure cleanup happens even if function errors
  on.exit({
    if (dir.exists(temp_dir)) {
      unlink(temp_dir, recursive = TRUE)
    }
  }, add = TRUE)
  
  # Render self-contained HTML
  message("Rendering self-contained HTML...")
  html_name <- paste0(yaml_data$date, "-", slug, ".html")
  
  quarto::quarto_render(
    input = qmd_file,
    output_format = "html",
    output_file = html_name,
    pandoc_args = c("--embed-resources", "--standalone")
  )
  
  # Find the HTML file - Quarto might put it in different locations
  html_locations <- c(
    file.path(post_path, html_name),
    file.path("docs/posts/posts", basename(post_path), html_name),
    file.path(dirname(dirname(dirname(post_path))), "docs/posts/posts", basename(post_path), html_name)
  )
  
  html_found <- FALSE
  for (loc in html_locations) {
    if (file.exists(loc)) {
      message("  Found HTML at: ", loc)
      file.copy(loc, file.path(bundle_dir, html_name), overwrite = TRUE)
      html_found <- TRUE
      break
    }
  }
  
  if (!html_found) {
    warning("Could not find rendered HTML file")
    message("  Searched in:")
    for (loc in html_locations) {
      message("    ", loc)
    }
  }
  
  # Include source files if requested
  if (include_source) {
    message("Including source files...")
    
    # Copy source files
    source_files <- list.files(post_path, 
                               pattern = "\\.(qmd|bib|stan|R|py)$",
                               full.names = TRUE)
    file.copy(source_files, bundle_dir)
    
    # Copy any data files
    if (dir.exists(file.path(post_path, "data"))) {
      dir.create(file.path(bundle_dir, "data"))
      file.copy(file.path(post_path, "data"), 
                bundle_dir, 
                recursive = TRUE)
    }
    
    # Copy any figure files
    fig_dirs <- list.files(post_path, 
                          pattern = "^.*_files$",
                          full.names = TRUE,
                          include.dirs = TRUE)
    for (fig_dir in fig_dirs) {
      if (dir.exists(fig_dir)) {
        file.copy(fig_dir, bundle_dir, recursive = TRUE)
      }
    }
    
    # Create README
    readme <- c(
      paste0("# ", yaml_data$title),
      "",
      paste0("**Author:** ", yaml_data$author),
      paste0("**Date:** ", yaml_data$date),
      "",
      if (!is.null(yaml_data$description) && nchar(yaml_data$description) > 0) {
        c(paste0("**Description:** ", yaml_data$description), "")
      },
      "## Contents",
      "",
      paste0("- `", html_name, "`: Self-contained HTML version of the blog post"),
      "- `index.qmd`: Source Quarto document",
      if (file.exists(file.path(post_path, "references.bib"))) "- `references.bib`: Bibliography",
      if (any(grepl("\\.stan$", source_files))) "- `*.stan`: Stan model files",
      if (dir.exists(file.path(post_path, "data"))) "- `data/`: Data files used in analysis",
      "",
      "## Reproducibility",
      "",
      "To reproduce this analysis:",
      "",
      "1. Ensure you have R and Quarto installed",
      "2. Install required R packages (see Session Info in the document)",
      "3. Run: `quarto render index.qmd`",
      "",
      "## Original URL",
      "",
      paste0("https://bruno.nicenboim.me/posts/posts/", yaml_data$date, "-", slug, "/"),
      "",
      if (!is.null(yaml_data$doi) && nchar(yaml_data$doi) > 0) {
        c("## DOI", "", paste0("https://doi.org/", yaml_data$doi), "")
      },
      "## License",
      "",
      "Please cite this work if you use it. See citation information in the HTML version.",
      ""
    )
    writeLines(readme, file.path(bundle_dir, "README.md"))
  }
  
  # Create ZIP archive
  message("Creating archive...")
  current_dir <- getwd()
  setwd(temp_dir)
  
  # Use zip package if available, otherwise use system zip
  if (requireNamespace("zip", quietly = TRUE)) {
    zip::zip(archive_path, 
             files = basename(bundle_dir),
             mode = "cherry-pick")
  } else {
    # Fallback to system zip command
    system2("zip", args = c("-r", archive_path, basename(bundle_dir)))
  }
  
  setwd(current_dir)
  
  message("✓ Archive created: ", archive_path)
  message("  Contents:")
  message("    - ", html_name)
  if (include_source) {
    message("    - Source files (index.qmd, *.bib, *.stan, etc.)")
    message("    - README.md")
  }
  
  invisible(archive_path)
}

#' Quick export PDF only
#'
#' If no post_path is provided, uses the currently open file in RStudio.
#'
#' @param post_path Path to post directory. If NULL, uses current file.
#' @export
export_post_pdf <- function(post_path = NULL) {
  
  # If no path provided, try to get current file from RStudio
  if (is.null(post_path)) {
    if (rstudioapi::isAvailable()) {
      current_file <- rstudioapi::getSourceEditorContext()$path
      if (nchar(current_file) == 0) {
        stop("No file is currently open in RStudio. Please specify post_path.")
      }
      post_path <- dirname(current_file)
      message("Using current file's directory: ", post_path)
    } else {
      stop("Not running in RStudio and no post_path provided. Please specify post_path.")
    }
  }
  
  if (!dir.exists(post_path)) {
    stop("Post directory not found: ", post_path)
  }
  
  qmd_file <- file.path(post_path, "index.qmd")
  yaml_data <- rmarkdown::yaml_front_matter(qmd_file)
  slug <- tolower(yaml_data$title)
  slug <- gsub("[^a-z0-9]+", "-", slug)
  slug <- gsub("^-|-$", "", slug)
  
  pdf_name <- paste0(yaml_data$date, "-", slug, ".pdf")
  
  message("Rendering PDF...")
  tryCatch({
    quarto::quarto_render(
      input = qmd_file,
      output_format = "pdf",
      output_file = pdf_name
    )
    message("✓ PDF created: ", file.path(post_path, pdf_name))
    invisible(file.path(post_path, pdf_name))
  }, error = function(e) {
    stop("PDF rendering failed: ", e$message, 
         "\n\nNote: This is often due to GIF images which LaTeX cannot handle.",
         "\nConsider removing GIFs or use export_post_html() instead.")
  })
}

#' Quick export self-contained HTML only
#'
#' If no post_path is provided, uses the currently open file in RStudio.
#'
#' @param post_path Path to post directory. If NULL, uses current file.
#' @export
export_post_html <- function(post_path = NULL) {
  
  # If no path provided, try to get current file from RStudio
  if (is.null(post_path)) {
    if (rstudioapi::isAvailable()) {
      current_file <- rstudioapi::getSourceEditorContext()$path
      if (nchar(current_file) == 0) {
        stop("No file is currently open in RStudio. Please specify post_path.")
      }
      post_path <- dirname(current_file)
      message("Using current file's directory: ", post_path)
    } else {
      stop("Not running in RStudio and no post_path provided. Please specify post_path.")
    }
  }
  
  if (!dir.exists(post_path)) {
    stop("Post directory not found: ", post_path)
  }
  
  qmd_file <- file.path(post_path, "index.qmd")
  yaml_data <- rmarkdown::yaml_front_matter(qmd_file)
  slug <- tolower(yaml_data$title)
  slug <- gsub("[^a-z0-9]+", "-", slug)
  slug <- gsub("^-|-$", "", slug)
  
  html_name <- paste0(yaml_data$date, "-", slug, ".html")
  
  message("Rendering self-contained HTML...")
  quarto::quarto_render(
    input = qmd_file,
    output_format = "html",
    output_file = html_name,
    pandoc_args = c("--embed-resources", "--standalone")
  )
  
  message("✓ HTML created: ", file.path(post_path, html_name))
  invisible(file.path(post_path, html_name))
}
