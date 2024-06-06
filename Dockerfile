# A docker file for establishing a spellcheck environment in R
FROM rocker/r-ver:4.4.0

# Labels following the Open Containers Initiative (OCI) recommendations
# For more information, see https://specs.opencontainers.org/image-spec/annotations/?v=v1.0.1
LABEL org.opencontainers.image.authors="CCDL ccdl@alexslemonade.org"
LABEL org.opencontainers.image.source="https://github.com/AlexsLemonade/spellcheck/tree/main"

# install R package dependencies from CRAN
RUN Rscript -e "install.packages(c('dplyr', 'purrr', 'readr', 'spelling', 'tidyr'))"

# add spell check script and make it executable
COPY spell-check.R /spell-check.R
RUN chmod +x /spell-check.R

ENTRYPOINT ["/spell-check.R"]
