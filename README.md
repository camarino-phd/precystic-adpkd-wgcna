# Weighted co-expression analysis of precystic ADPKD kidneys

Analysis code for *"Weighted Co-expression Reveals Early Circadian and Metabolic
Dysregulation in Precystic Kidneys"* (Marino, Kunnen, van de Water, Peters).

The pipeline takes staged *Pkd1* conditional-knockout mouse RNA-seq (gene-level
log2 fold changes), projects them onto the 347 curated rat kidney co-expression
modules of the TXG-MAPr framework, selects transcriptionally active modules, and
runs functional and transcription-factor enrichment on the selected set.

Eigengene scores are not computed in this repository. They are computed by the
TXG-MAPr web tool (https://txg-mapr.eu). Script 01 produces the upload file, the
platform returns `moduleTable.txt` and `geneTable.txt`, and script 02 reads those
back in. The one manual web step sits between scripts 01 and 02 (see Run order).

## Repository structure

```
.
├── code/
│   ├── 00_environment.R           # load packages (run first, every session)
│   ├── 01_prepare_upload.Rmd      # log2FC -> rat-ortholog TXG-MAPr upload file
│   ├── 02_assemble_egs_matrix.Rmd # parse TXG-MAPr output -> gene x module EGS matrix
│   └── 03_analysis_and_figures.Rmd# module selection, ORA, TF enrichment, figures
├── data/                          # inputs (see Data provenance) + generated intermediates
├── results/                       # regenerated outputs (git-ignored)
├── LICENSE                        # BSD 3-Clause
└── README.md
```

## Requirements

R (>= 4.0). All dependencies are on CRAN. Run `code/00_environment.R` first. It
installs anything missing and prints `sessionInfo()` for the exact versions used.

Open `precystic-adpkd-wgcna.Rproj` in RStudio before running anything, or set the
working directory to the repository root. The scripts resolve input and output
paths with `here`, which anchors on the `.here` file (or the `.Rproj`) at the root.
Running from any other directory fails with a "could not find associated project"
error.

## Run order

Scripts are numbered in execution order. One manual step on the TXG-MAPr website,
between 01 and 02, cannot be automated.

1. `00_environment.R`: load packages.
2. `01_prepare_upload.Rmd`: reads the mouse log2FC tables, maps mouse to rat
   orthologs, and writes the TXG-MAPr upload file
   `results/<date>/txg_mapr_upload_rat_symbols.txt`. Also produces the DEG counts
   (Table 1), the ortholog mapping summary (Supplementary Table 2), and the
   volcano plots (Figure 2).
3. Manual TXG-MAPr step: log in to https://txg-mapr.eu, upload
   `txg_mapr_upload_rat_symbols.txt`, run the projection, download the result
   archive, and unzip it to `data/TXG-MAPr_Results_Unzipped/` so that
   `moduleTable.txt` and `geneTable.txt` are present.
4. `02_assemble_egs_matrix.Rmd`: joins the platform output with the ortholog table
   and writes the gene × module × condition eigengene-score matrix
   `data/new_wgcna.csv` / `.xlsx` (Supplementary Table 3).
5. `03_analysis_and_figures.Rmd`: module selection (85th-percentile EGS filter),
   functional enrichment (Enrichr), TF enrichment (TRRUST-v2), the percentile
   robustness check across the 80th to 90th percentile range, and Figures 4, 5,
   and 6.

## Output map (figures and tables)

| Manuscript item | Produced by |
| --- | --- |
| Table 1 (DEG counts) | 01 |
| Figure 2 (volcano plots) | 01 |
| Supplementary Table 1 (TXG-MAPr upload / ortholog-mapped log2FC) | 01 |
| Supplementary Table 2 (mouse-to-rat ortholog mapping) | 01 |
| Supplementary Table 3 (gene × module EGS matrix, all 347 modules) | 02 |
| Figure 4 (module EGS heatmap + top-gene heatmap) | 03 |
| Figure 5 (functional enrichment) | 03 |
| Figure 6 (TF-module chord diagram) | 03 |
| Supplementary Table 4 (ORA per module) | 03 |
| Supplementary Tables 5–6 (TF-module enrichment) | 03 |
| Percentile robustness check | 03 |

Figures 1, 3, and 8 are not generated here. Figure 1 and Supplementary Figure 1
are workflow schematics. The circular dendrograms (Figures 3 and 8) are exported
from the TXG-MAPr platform.

## Data provenance

Place the following files under `data/`. Third-party inputs are redistributed only
where their licence allows. Otherwise, obtain them from the listed source.

| File | Source | Notes |
| --- | --- | --- |
| `earlyPKDmodels.xlsx` | Precystic (wk2/3/6) log2FC. Provided as Supplementary Table 1 (early-stage sheet) of this manuscript; original values from Kunnen et al. 2018 (*Biomed Pharmacother*) Suppl. Table S9 | authors' own work |
| `Pkd1cko_NoRapa_WT.xlsx` | Moderate/advanced log2FC. Provided as Supplementary Table 1 (moderate/advanced sheet) of this manuscript; raw data ArrayExpress **E-MTAB-8086** (Malas et al. 2020) | authors' own work |
| `ORTHOLOGS_RAT.txt` | Rat Genome Database (RGD) ortholog table, release 2025-07-26 | cite RGD; verify redistribution terms |
| `trrust_rawdata.mouse.tsv` | TRRUST v2 (Han et al. 2018) | CC-BY; redistribute with citation |
| `TXG-MAPr_Results_Unzipped/moduleTable.txt`, `geneTable.txt` | Generated via TXG-MAPr from the script-01 upload | projection output |

Raw RNA-seq: ArrayExpress **E-MTAB-8086**. Reference network: TXG-MAPr
(https://txg-mapr.eu; Kunnen et al. 2025, *iScience*, and Zenodo
https://doi.org/10.5281/zenodo.14926143).

## License

Code is released under the BSD 3-Clause License, Copyright (c) 2026 Cesare A.
Marino (see `LICENSE`).

## Citation

Marino CA, Kunnen SJ, van de Water B, Peters DJM. *Weighted Co-expression Reveals
Early Circadian and Metabolic Dysregulation in Precystic Kidneys.* https://doi.org/10.5281/zenodo.21924061
