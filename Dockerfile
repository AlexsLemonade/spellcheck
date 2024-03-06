# A docker file for establishing a spellcheck environment in R
FROM rocker/r-ver:4.3.2

# Labels following the Open Containers Initiative (OCI) recommendations
# For more information, see https://specs.opencontainers.org/image-spec/annotations/?v=v1.0.1
LABEL org.opencontainers.image.authors="CCDL ccdl@alexslemonade.org"
LABEL org.opencontainers.image.source="https://github.com/AlexsLemonade/spellcheck/tree/main"

# install the spelling and tidyr packages from CRAN
RUN Rscript -e "install.packages(c('spelling', 'tidyr'))"

# add spell check script and make it executable
COPY spelling.R /usr/local/bin/spell-check.R
RUN chmod +x /usr/local/bin/spell-check.R
