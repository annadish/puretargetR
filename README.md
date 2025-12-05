# puretargetR <img src="https://img.shields.io/badge/made%20with-R-blue.svg"> <img src="https://img.shields.io/badge/license-MIT-green"> <img src="https://img.shields.io/badge/version-v0.1.0-lightgrey">

puretargetR is a lightweight, R toolkit that transforms CSV outputs from TRGT into summaries of repeat composition across all loci and samples. 
It parses allele-specific motif counts, identifies dominant repeat motifs, and includes inheritance-aware repeat expansion classification - all without re-alignment or BAM file access. puretargetR enables quick visualization of repeat motif diversity at the cohort-level. 

## Rationale & Impact
Repeat expansions are among the most challenging variant types to interpret — especially when alleles differ in length, motif composition, or methylation status. TRGT detects these expansions using long-read sequencing data, but the resulting CSV files are often dense and difficult to interpret without coding expertise. 

puretargetR bridges that gap by turning TRGT PureTarget Reports into clean, analysis ready summaries that highlight:
 - allele specific repeat structure
 - dominant and rare motifs
 - motif diversity within and across individuals
 - pathogenic vs normal vs intermediate vs premutation alleles
 - inheritance-aware sample classifications 
   
This toolkit is designed for translational researchers, clinicians, etc. who want to:
Rapidly visualize and summarize repeat composition per locus and sample
Compare expansion motifs across individuals or disease groups
Support diagnostic interpretation or publication-ready figures

## Features
- Converts PureTarget CSV exports into tidy long- and wide-format tables
- Summarizes per-locus dominant motifs and total repeat counts
- Identifies the canonical (modal) motif per locus and identifies rare motifs
- Generates motif presence/absence matrices and diversity metrics
- Includes an expansion classifier (AD/AR/XLD/XLR/XD) (autosomal dominant/recessive, X-linked. etc.)
- Enables rapid visualization of cohort-level comparisons

## Folder structure
- R/ — Core modular functions 
- data/ — Small example dataset (example_re_long.csv)
- docs/ — Usage guide
- scripts/ — Reproducible standalone workflows
  
## Pipeline Overview
<pre> TRGT CSVs (long format) │ ├──▶ make_summary_wide() │ ↓ df_summary_wide │ ├──▶ classify_motif() ├──▶ classify_inheritance() ├──▶ classify_expansions() ← full analysis (locus + sample calls) │ ├──▶ make_repeat_summary() ├──▶ make_motif_per_sample() ├──▶ make_motif_presence() └──▶ make_diversity() </pre>

## Outputs
The pipeline produces structural summaries:
- `df_summary_wide` — all allele-level features
- `repeat_summary` — consensus sizes, spans, read counts

Motif-level summaries:
- `motif_freq_individual` — motif counts/frequencies per sample
- `presence_objs` — motif presence & cohort-level motif spectrum
- `diversity_tbl` — Shannon diversity, motif richness, dominant motif
  
Expansion classifier outputs (NEW)
The classify_expansions() wrapper performs full allele → locus → sample interpretation and returns a list with:
- allele_calls (one row per allele including: motif count, motif class, allele status, and inheritance model)
- locus_calls (one row per sample/locus)
- sample_calls (summary of expansion type per sample)
- locus_summary (cohort-level counts per locus)
  
## License
This project is released under the MIT License.

## Citation
If you use puretargetR in your research, please cite:

> Dias Lab, A. Dischler et al. (2025). *puretargetR: A modular R pipeline for quick allele-resolved repeat and motif diversity analysis.* GitHub Repository.  
> [https://github.com/annadish/puretargetR](https://github.com/annadish/puretargetR)

## Quick Start (no installation needed)
You can load all core functions directly from GitHub:

```r
# ===============================================================
# Install + Load PureTargetR
# ===============================================================

install.packages("devtools")   # run once
library(devtools)

# Load all PureTargetR functions from GitHub
source_url("https://raw.githubusercontent.com/annadish/puretargetR/main/R/load_pipeline.R")
load_puretargetR_pipeline()

# ===============================================================
# Load example PureTarget TRGT dataset
# ===============================================================

df_long_clean <- readr::read_csv(
  "https://raw.githubusercontent.com/annadish/puretargetR/main/data/example_re_long.csv"
)

# Inspect structure
dplyr::glimpse(df_long_clean)

# ===============================================================
# Run PureTargetR core pipeline
# ===============================================================

# 1. Convert to wide format (allele-level summary)
df_summary_wide <- make_summary_wide(df_long_clean)

# 2. Compute repeat-level features
repeat_summary <- make_repeat_summary(df_summary_wide)

# 3. Motif-level summaries
motif_objs    <- make_motif_per_sample(df_summary_wide)
presence_objs <- make_motif_presence(motif_objs$motif_freq_individual)

# 4. Motif diversity by locus/sample
diversity_tbl <- make_diversity(
  motif_objs$motif_freq_individual,
  df_summary_wide
)

# 5. Full expansion classifier (motif + inheritance + pathogenicity)
expansion_results <- classify_expansions(df_summary_wide)

# ===============================================================
# View results
# ===============================================================

head(expansion_results$allele_calls)
head(expansion_results$locus_calls)
head(expansion_results$sample_calls)
expansion_results$locus_summary

head(df_summary_wide)
head(repeat_summary)
head(diversity_tbl)
