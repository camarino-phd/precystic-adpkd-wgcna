## 00_environment.R
## Initialize the R environment for the analysis pipeline.
## Run first in every session; scripts 01-03 assume these packages are loaded.
## The pipeline is CRAN-only (eigengene scores are computed by the TXG-MAPr
## web tool, not in R, so no WGCNA/Bioconductor dependency is required here).

cran_pkgs <- c(
  "dplyr", "tidyr", "tibble", "readr", "readxl", "here", "rlang",
  "ggplot2", "ggrepel", "pheatmap", "RColorBrewer", "viridis", "scales",
  "circlize", "igraph", "ggraph", "ggdendro", "patchwork",
  "gridExtra", "gtable", "cluster", "enrichR",
  "openxlsx", "writexl"
)

missing_cran <- setdiff(cran_pkgs, rownames(installed.packages()))
if (length(missing_cran)) {
  install.packages(missing_cran, repos = "https://cran.rstudio.com/")
}

invisible(lapply(cran_pkgs, library, character.only = TRUE))

## Record exact package versions for reproducibility.
print(utils::sessionInfo())
