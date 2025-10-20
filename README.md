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
