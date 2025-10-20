# puretargetR
puretargetR is a lightweight, R toolkit that transforms CSV outputs from TRGT into summaries of repeat composition across all loci and samples. It parses allele-specific motif counts and identifies dominant repeat motifs—without re-alignment or BAM access, enabling quick visualization of repeat motif diversity at the cohort-level. 

# Features
- Converts PureTarget CSV exports into tidy long-format tables
- Summarizes per-locus dominant motifs and total repeat counts
- Motif parsing and frequency analysis
- Cohort-level summaries and visualization
- Works across all alleles and loci simultaneously
- Generates per-sample motif composition summaries
- Optional visualization functions

# Folder structure
- R/ — Core modular functions (each a clean R file)
- scripts/ — Reproducible scripts that call these functions
- data/ — Example input/output
- outputs/ — Figures and tables

# License
This project is released under the MIT License.

# Quick Start (no installation needed)
You can load all core functions directly from GitHub:

```r
install.packages("devtools")
library(devtools)
source_url("https://raw.githubusercontent.com/annadish/puretargetR/main/R/load_pipeline.R")
load_puretargetR_pipeline()

# Example usage
#Load in practice long-format repeat expansion table
df_long_clean <- readr::read_tsv("https://raw.githubusercontent.com/annadish/puretargetR/main/data/example_df_long_clean.tsv")

#Run the full analysis pipeline
df_summary_wide <- make_summary_wide(df_long_clean)
repeat_summary  <- make_repeat_summary(df_summary_wide)
motif_objs      <- make_motif_per_sample(df_summary_wide)
presence_objs   <- make_motif_presence(motif_objs$motif_freq_individual)
diversity_tbl   <- make_diversity(motif_objs$motif_freq_individual, df_summary_wide)

#Inspect results
head(df_summary_wide)
head(repeat_summary)
head(diversity_tbl)


