# puretargetR
puretargetR is a lightweight, R toolkit that transforms CSV outputs from TRGT into summaries of repeat composition across all loci and samples. It parses allele-specific motif counts and identifies dominant repeat motifs—without re-alignment or BAM access, enabling quick visualization of repeat motif diversity at the cohort-level. 

# Features
- Converts PureTarget CSV exports into tidy long-format tables
- Summarizes per-locus dominant motifs and total repeat counts
- Works across all alleles and loci simultaneously
- Generates per-sample motif composition summaries
- Optional visualization functions (forecoming)

# Example Dataset

This repository includes a small cleaned dataset (`example_re_long.csv`) derived from the original PureTarget 2.0 repeat expansion report, publicly accessible here https://downloads.pacbcloud.com/public/dataset/PureTarget2.0/PureTarget-Repeat2.0-Datasets/Repeat2.0_NanobindCoriell_48plex_RevioSRPQ/

This demonstrates the long-format data structure used in `summarize_locus_long()` and related functions.
