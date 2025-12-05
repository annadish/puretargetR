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
   
This toolkit is designed for translational researchers, clinicians, etc. who want to rapidly visualize/summarize repeat composition per locus/sample, compare expansion motifs across individuals or disease groups, and create figures.

## Features
- Converts PureTarget CSV exports into tidy long- and wide-format tables
- Summarizes per-locus dominant motifs and total repeat counts
- Identifies the canonical (modal) motif per locus and identifies rare motifs
- Generates motif presence/absence matrices and diversity metrics
- Includes an expansion classifier (AD/AR/XLD/XLR/XD) (autosomal dominant/recessive, X-linked. etc.)
- Enables rapid visualization of cohort-level comparisons

## Folder structure
- `R/` — Core modular functions  
- `data/` — Small example dataset  
- `docs/` — Usage guide  
- `scripts/` — Reproducible scripts that call these functions  

## Pipeline Overview
<pre>
TRGT CSVs
   │
   ├──▶ make_summary_wide()
   │        ↓
   │     df_summary_wide
   │        ↓
   ├──▶ classify_motif()
   ├──▶ classify_inheritance()
   ├──▶ classify_expansions()    ← full expansion classifier
   │
   ├──▶ make_repeat_summary()
   ├──▶ make_motif_per_sample()
   ├──▶ make_motif_presence()
   └──▶ make_diversity()
</pre>

## Outputs
The pipeline produces:

### **Structural summaries**
- `df_summary_wide` — all allele-level features  
- `repeat_summary` — consensus sizes, spans, read counts  

### **Motif-level summaries**
- `motif_freq_individual` — motif counts/frequencies per sample  
- `presence_objs` — motif presence & cohort-level motif spectrum  
- `diversity_tbl` — Shannon diversity, motif richness, dominant motif  

---

### **Expansion classifier outputs (NEW)**  
The `classify_expansions()` wrapper performs full allele → locus → sample interpretation and returns a list with:

#### **1. `allele_calls`**  
One row per allele, including:  
- motif count  
- motif class (canonical / rare / mixed)  
- allele_status (normal / intermediate / premutation / pathogenic)  
- inheritance model  

#### **2. `locus_calls`**  
One row per sample × locus, providing inheritance-aware interpretation:  
- **affected (AR, biallelic)** — two pathogenic alleles  
- **carrier (AR)** — one pathogenic allele  
- **affected/carrier (AD)** — one or more pathogenic alleles  
- **affected (XLD)** — pathogenic allele on X chromosome  
- **carrier (XLR)** — heterozygous female carrier  
- **normal** — no pathogenic alleles  

#### **3. `sample_calls`**  
One row per sample, summarizing overall expansion status:  
- `has_reportable_expansion`  
- `carrier_only`  
- `all_normal`  

#### **4. `locus_summary`**  
Cohort-level counts of individuals with expansions or carriers per locus:
- number of AR affected  
- number of AR carriers  
- number of AD expansions  
- number of X-linked affected / carriers  

---

## License
This project is released under the MIT License.

## Citation
If you use puretargetR in your research, please cite:

> Dias Lab, A. Dischler et al. (2025). *puretargetR: A modular R pipeline for quick allele-resolved repeat and motif diversity analysis.* GitHub Repository.  
> https://github.com/annadish/puretargetR

## Quick Start (no installation needed)
```r
install.packages("devtools")
library(devtools)

source_url("https://raw.githubusercontent.com/annadish/puretargetR/main/R/load_pipeline.R")
load_puretargetR_pipeline()

df_long_clean <- readr::read_csv(
  "https://raw.githubusercontent.com/annadish/puretargetR/main/data/example_re_long.csv"
)

df_summary_wide <- make_summary_wide(df_long_clean)
repeat_summary  <- make_repeat_summary(df_summary_wide)
motif_objs      <- make_motif_per_sample(df_summary_wide)
presence_objs   <- make_motif_presence(motif_objs$motif_freq_individual)
diversity_tbl   <- make_diversity(motif_objs$motif_freq_individual, df_summary_wide)

expansion_results <- classify_expansions(df_summary_wide)

head(expansion_results$allele_calls)
head(expansion_results$locus_calls)
head(expansion_results$sample_calls)
expansion_results$locus_summary
