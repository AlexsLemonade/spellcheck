#!/usr/bin/env Rscript
#
# Run spell check and save results.
# By default, all R Markdown and markdown files will be checked.
# To modify this behavior, provide a command-line argument with the extensions to check.

arguments <- commandArgs(trailingOnly = TRUE)
file_pattern <- "\\.(Rmd|md|rmd)$"

# dictionary is required first argument
dict_file <- arguments[1]

arguments <- arguments[-1]
# if there are arguments, check those files, otherwise check all markdown & rmd files
if (length(arguments) > 1) {
  files <- arguments[grepl(file_pattern, arguments)]
} else {
  files <- list.files(pattern = file_pattern, recursive = TRUE, full.names = TRUE)
}

if (file.exists(dict_file)) {
    dictionary <- readLines(dict_file)
} else {
    warning("Dictionary file not found")
    dictionary <- ""
}

# Run spell check
spelling_errors <- spelling::spell_check_files(files, ignore = dictionary) |>
  data.frame() |>
  tidyr::unnest(cols = found) |>
  tidyr::separate(found, into = c("file", "lines"), sep = ":")


# Save spelling errors to file
write.table(spelling_errors, "spell_check_errors.tsv", sep = "\t", quote = FALSE)

# Save error count to GITHUB_OUTPUT
system(paste0("echo 'error_count=", nrow(spelling_errors), "'>> $GITHUB_OUTPUT"))
