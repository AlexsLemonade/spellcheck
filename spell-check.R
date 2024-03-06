#!/usr/bin/env Rscript
#
# Run spell check and save results.
# By default, all R Markdown and markdown files will be checked.
# To modify this behavior, provide a command-line argument with the extensions to check.

arguments <- commandArgs(trailingOnly = TRUE)
file_pattern <- "\\.(Rmd|md|rmd)$"

# if there are arguments, check those files, otherwise check all markdown & rmd files
if (length(arguments) > 0) {
  files <- arguments[grepl(file_pattern, arguments)]
} else {
  files <- list.files(pattern = file_pattern, recursive = TRUE, full.names = TRUE)
}

# Find .git root directory
root_dir <- rprojroot::find_root(rprojroot::has_dir(".git"))

# Read in dictionary
dict_file <- file.path(root_dir, "components", "dictionary.txt")
dictionary <- readLines(dict_file)

# Run spell check
spelling_errors <- spelling::spell_check_files(files, ignore = dictionary_plus) |>
  data.frame() |>
  tidyr::unnest(cols = found) |>
  tidyr::separate(found, into = c("file", "lines"), sep = ":")

# Print out how many spell check errors
write(nrow(spelling_errors), stdout())

# Save spell errors to file
readr::write_tsv(spelling_errors, "spell_check_errors.tsv")
