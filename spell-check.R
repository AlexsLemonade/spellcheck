#!/usr/bin/env -S Rscript --vanilla
#
# Run spell check and save results.
# By default, all R Markdown and markdown files will be checked.
# To modify this behavior, provide a command-line argument with the extensions to check.

arguments <- commandArgs(trailingOnly = TRUE)

file_pattern <- "(?i)\\.(md|rmd)$"

# dictionary is required first argument
dict_file <- arguments[1]

arguments <- arguments[-1]
# if there are arguments, check those files, otherwise check all markdown & rmd files
if (length(arguments) > 0 && arguments[1] != "") {
  files_glob <- strsplit(arguments, " ") |>
    unlist() |>
    Sys.glob() |>
    unique()
  files <- grep(file_pattern, files_glob, value = TRUE)
} else {
  files <- list.files(pattern = file_pattern, recursive = TRUE, full.names = TRUE)
}

if (file.exists(dict_file)) {
  # Reading in the dictionary this way lets us put emojis in the dictionary file
  dictionary <- spelling::spell_check_files(dict_file)$word
} else {
  warning("Dictionary file not found")
  dictionary <- ""
}


# Separate files into path groups
file_list <- split(files, dirname(files))


# check spelling for all files in each path, and prepend the file path
#  to the file name in the final data frame
spelling_errors <- all_paths |>
  purrr::map(
    \(path) {
      list.files(path = path, pattern = file_pattern) |>
        spelling::spell_check_files(ignore = dictionary) |>
        data.frame() |>
        tidyr::unnest(cols = found) |>
        tidyr::separate(found, into = c("file", "lines"), sep = ":") |>
        dplyr::mutate(file = file.path(path, file))
    }
  ) |>
  dplyr::bind_rows()


# Save spelling errors to file
readr::write_tsv(spelling_errors, "spell_check_errors.tsv")

# Save error count to GITHUB_OUTPUT
system(paste0("echo 'error_count=", nrow(spelling_errors), "'>> $GITHUB_OUTPUT"))
