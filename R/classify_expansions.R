# =====================================================================
# classify_expansions.R
# puretargetR | Full expansion classifier (motif + inheritance)
# Author: Dias Lab (A. Dischler)
# =====================================================================

#' Full repeat expansion classifier for PureTarget datasets
#'
#' This is the main high-level wrapper function. It:
#'   1. Annotates motifs using classify_motif()
#'   2. Classifies alleles using inheritance-aware cutoffs
#'   3. Generates locus-level interpretations (AD / AR / XLD / XLR)
#'   4. Summarizes sample-level expansion burden
#'   5. Summarizes per-locus expansion frequencies
#'
#' @param df_summary_wide Output of make_summary_wide()
#'
#' @return A list with:
#'   - allele_calls   (long allele-level table)
#'   - locus_calls    (one row per locus per sample)
#'   - sample_calls   (summary per sample)
#'   - locus_summary  (summary per locus)
#'
#' @export
#'
classify_expansions <- function(df_summary_wide) {

  # --------------------------------------------------------------
  # 1. Motif annotation (wide format returned)
  # --------------------------------------------------------------
  motif_df <- classify_motif(df_summary_wide)

  # --------------------------------------------------------------
  # 2. Inheritance-aware allele classification (long format returned)
  # --------------------------------------------------------------
  allele_calls <- classify_inheritance(motif_df)

  # --------------------------------------------------------------
  # 3. Per-locus interpretation (dominant / recessive logic)
  # --------------------------------------------------------------
  locus_calls <- allele_calls %>%
    group_by(sample, locus) %>%
    summarise(
      inheritance = first(inheritance),
      a0_status = allele_status[allele == "0"],
      a1_status = allele_status[allele == "1"],
      pathogenic_alleles = sum(allele_status == "pathogenic"),
      .groups = "drop"
    ) %>%
    mutate(
      locus_call = dplyr::case_when(
        inheritance == "AR" & pathogenic_alleles == 2 ~ "affected (AR, biallelic)",
        inheritance == "AR" & pathogenic_alleles == 1 ~ "carrier (AR)",
        inheritance == "AD" & pathogenic_alleles >= 1 ~ "affected/carrier (AD)",
        inheritance == "XLD" & pathogenic_alleles >= 1 ~ "affected (XLD)",
        inheritance == "XLR" & pathogenic_alleles >= 1 ~ "carrier (XLR)",
        TRUE ~ "normal"
      )
    )

  # --------------------------------------------------------------
  # 4. Sample-level summary
  # --------------------------------------------------------------
  sample_calls <- summarize_cohort(locus_calls)

  # --------------------------------------------------------------
  # 5. Locus-level summary
  # --------------------------------------------------------------
  locus_summary <- summarize_locus_expansions(locus_calls)

  # --------------------------------------------------------------
  # Return structured output
  # --------------------------------------------------------------
  return(list(
    allele_calls   = allele_calls,
    locus_calls    = locus_calls,
    sample_calls   = sample_calls,
    locus_summary  = locus_summary
  ))
}

out <- classify_expansions(df_summary_wide)
