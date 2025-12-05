# =====================================================================
# classify_inheritance.R
# puretargetR | Apply inheritance-aware allele classification
# Author: Dias Lab (A. Dischler)
# =====================================================================

#' Classify allele pathogenicity using PureTargetR cutoff table.
#'
#' This function takes the wide-format motif table produced by classify_motif(),
#' adds numeric repeat count cutoffs, reshapes to long format, and assigns each
#' allele a category:
#'   - normal
#'   - intermediate
#'   - premutation
#'   - pathogenic
#'
#' @param df A motif-annotated df_summary_wide table
#'
#' @return A long-format tibble with columns:
#'   locus, sample, allele, motif_count, allele_status, inheritance
#'
#' @export
#'
classify_inheritance <- function(df) {

  # --------------------------------------------------------------
  # 1. Extract motif counts numerically (e.g., "14_0" → 14)
  # --------------------------------------------------------------
  df2 <- df %>%
    mutate(
      motif_count_a0 = as.numeric(stringr::str_extract(motif_counts_allele0, "^\\d+")),
      motif_count_a1 = as.numeric(stringr::str_extract(motif_counts_allele1, "^\\d+"))
    )

  # --------------------------------------------------------------
  # 2. Convert to long format
  # --------------------------------------------------------------
  long <- df2 %>%
    select(locus, sample, motif_count_a0, motif_count_a1) %>%
    tidyr::pivot_longer(
      cols = c(motif_count_a0, motif_count_a1),
      names_to = "allele",
      values_to = "motif_count"
    ) %>%
    mutate(
      allele = dplyr::recode(allele,
                             "motif_count_a0" = "0",
                             "motif_count_a1" = "1"),
      allele = factor(allele)
    )

  # --------------------------------------------------------------
  # 3. Attach PureTarget cutoff table (centralized)
  # --------------------------------------------------------------
  long <- long %>% left_join(puretargetR_cutoffs(), by = "locus")

  # --------------------------------------------------------------
  # 4. Classify allele status using numeric rules
  # --------------------------------------------------------------
  long <- long %>%
    mutate(
      allele_status = case_when(
        !is.na(pathogenic_min) & motif_count >= pathogenic_min ~ "pathogenic",
        !is.na(premutation_min) & motif_count >= premutation_min ~ "premutation",
        !is.na(intermediate_min) & motif_count >= intermediate_min & motif_count <= intermediate_max ~ "intermediate",
        motif_count <= normal_max ~ "normal",
        TRUE ~ "unknown"
      )
    )

  return(long)
}
