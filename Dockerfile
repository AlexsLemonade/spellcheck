# A docker file for establishing a spellcheck environment in R
FROM rocker/tidyverse:4.2.3

# Labels following the Open Containers Initiative (OCI) recommendations
# For more information, see https://specs.opencontainers.org/image-spec/annotations/?v=v1.0.1
LABEL org.opencontainers.image.authors="CCDL ccdl@alexslemonade.org"
LABEL org.opencontainers.image.source="https://github.com/AlexsLemonade/spellcheck/tree/main"

# install the spelling package from CRAN
RUN Rscript --vanilla -e "install.packages('spelling')"
