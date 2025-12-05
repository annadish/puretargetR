# ================================================================
# classify_motif.R
# puretargetR | Motif-aware classification
# Author: Dias Lab (A. Dischler)
# ================================================================

#' General motif classifier for PureTarget repeat units
#'
#' This function performs motif annotation for all loci in the PureTarget2.0 panel.
#' It extracts the motif for each allele from the PureTarget
#' repeat_unit column.
#'
#' It does NOT assign pathogenicity and does NOT encode any
#' locus-specific biological rules. Instead, it provides simple
#' structural categories that can be used downstream:
#'
#'   - "canonical" : the motif matches the modal motif for this locus
#'   - "rare"      : motif is valid but does not match the modal motif
#'   - "mixed"     : sample’s two alleles use different motifs
#'   - "unknown"   : missing or unparsable motif

#' @details
#' PureTargetR defines the "canonical" motif for each locus as the motif
#' most frequently observed in the input dataset. This makes the classifier
#' flexible across different cohorts and sequencing panels, and avoids
#' assumptions about biologically correct motifs. Motifs not matching the
#' dataset-derived canonical motif are labeled as "rare."

#' @param df A df_summary_wide table from make_summary_wide()
#'
#' @return A tibble with:
#'   - motif_a0
#'   - motif_a1
#'   - motif_class_a0
#'   - motif_class_a1
#'   - motif_pair_class
#'
#' @export
#'
classify_motif <- function(df) {

  # --------------------------------------------------------------
  # Extract motifs
  # --------------------------------------------------------------
  df2 <- df %>%
    mutate(
      motif_a0 = ifelse(!is.na(repeat_unit),
                        stringr::str_split(repeat_unit, ":", simplify = TRUE)[,1],
                        NA),
      motif_a1 = ifelse(!is.na(repeat_unit),
                        stringr::str_split(repeat_unit, ":", simplify = TRUE)[,2],
                        NA)
    )

  # --------------------------------------------------------------
  # Determine modal ("canonical") motif per locus
  # --------------------------------------------------------------
  canonical_table <- df2 %>%
    select(locus, motif_a0, motif_a1) %>%
    pivot_longer(cols = c(motif_a0, motif_a1), names_to = "allele", values_to = "motif") %>%
    filter(!is.na(motif)) %>%
    group_by(locus, motif) %>%
    summarise(n = n(), .groups = "drop") %>%
    group_by(locus) %>%
    slice_max(order_by = n, n = 1, with_ties = FALSE) %>%
    rename(canonical_motif = motif)

  df3 <- df2 %>% left_join(canonical_table, by = "locus")

  # --------------------------------------------------------------
  # Classify each allele
  # --------------------------------------------------------------
  df4 <- df3 %>%
    mutate(
      motif_class_a0 = case_when(
        is.na(motif_a0) ~ "unknown",
        motif_a0 == canonical_motif ~ "canonical",
        TRUE ~ "rare"
      ),
      motif_class_a1 = case_when(
        is.na(motif_a1) ~ "unknown",
        motif_a1 == canonical_motif ~ "canonical",
        TRUE ~ "rare"
      ),
      motif_pair_class = case_when(
        is.na(motif_a0) | is.na(motif_a1) ~ "unknown",
        motif_a0 == motif_a1 ~ "homogeneous",
        motif_a0 != motif_a1 ~ "mixed"
      )
    )

  return(df4)
}
