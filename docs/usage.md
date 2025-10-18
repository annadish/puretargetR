# Example: Summarizing a PureTarget Locus

This example uses the included example dataset (`data/example_re_long.csv`)  
and the main summarization function (`scripts/summarize_locus_long.R`).

```r
# Load required packages
library(dplyr)
library(stringr)
library(tidyr)
library(janitor)
source("scripts/summarize_locus_long.R")

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
