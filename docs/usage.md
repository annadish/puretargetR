This repository provides a modular R pipeline for analyzing repeat expansion data (e.g., PacBio Repeat Expansion 2.0 panels) across cohorts.
It converts raw long-format tables into structured summaries, computes per-allele motif composition, motif frequencies, and entropy-based diversity metrics, and generates cohort-level plots.

**puretargetR/**
├── R/
│   ├── make_summary_wide.R
│   ├── make_repeat_summary.R
│   ├── make_motif_per_sample.R
│   ├── make_motif_presence.R
│   ├── make_diversity.R
│   ├── make_panels.R
├── scripts/
│   ├── example_pipeline.R
│   ├── test_make_repeat_summary.R
├── data/
│   ├── example_df_long_clean.tsv
├── README.md
└── USAGE.md   ← this file

# Prerequisits in R:

# Load required packages
install.packages(c(
  "tidyverse",
  "janitor",
  "purrr",
  "stringr",
  "dplyr",
  "tidyr"
))

# Step 1: Source functions
source("R/make_summary_wide.R")
source("R/make_repeat_summary.R")
source("R/make_motif_per_sample.R")
source("R/make_motif_presence.R")
source("R/make_diversity.R")


# Load example dataset
example_re_long <- read.csv("data/example_re_long.csv")

# Rename columns to match function expectations
example_re_long_ready <- example_re_long %>%
  rename(
    Locus = SampleGroup,
    Feature = Feature_sub,
    Type = Feature_type,
    Allele = Allele_num
  )

# Summarize one locus (SCA37_DAB1)
summary_table <- summarize_locus_long(example_re_long_ready, "SCA37_DAB1")

# Print result
print(summary_table)

# Expected output:
# A tibble: 6 × 6
  Locus      Genotype  dominant_motif_allele0 total_repeats_allele0
  <chr>      <chr>     <chr>                  <dbl>
1 SCA37_DAB1 R2_GV-01  AAAAT                  15
2 SCA37_DAB1 R2_GV-02  AAAAT                  15
3 SCA37_DAB1 R2_GV-03  AAAAT                  15
4 SCA37_DAB1 R2_GV-04  AAAAT                  15
5 SCA37_DAB1 R2_GV-05  AAAAT                  12
6 SCA37_DAB1 R2_GV-06  AAAAT                  12

---

# Summarizing All Loci

This summarizes every locus in your dataset in one step:

```r
# Summarize all loci at once
all_loci_summary <- unique(example_re_long_ready$Locus) %>%
  map_df(~summarize_locus_long(example_re_long_ready, .x))

# Preview results
head(all_loci_summary)
