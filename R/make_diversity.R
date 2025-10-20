#' make_diversity
#'
#' Calculate Shannon entropy, dominant motif, and attach consensus size/read count per allele.
#'
#' @param motif_freq_individual Tibble with columns locus, sample, allele, motif, proportion
#' @param df_summary_wide Tibble with summary numeric columns (e.g. consensus_size_a0/a1)
#' @return Tibble of per-sample × allele diversity metrics
#' @export
make_diversity <- function(motif_freq_individual, df_summary_wide) {
  
  motif_diversity <- motif_freq_individual %>%
    group_by(locus, sample, allele) %>%
    summarise(
      entropy = shannon_entropy(proportion),
      dominant_motif = motif[which.max(proportion)],
      dominant_fraction = max(proportion, na.rm = TRUE),
      n_motifs_present = sum(proportion > 0, na.rm = TRUE),
      .groups = "drop"
    )
  
  add_sizes <- df_summary_wide %>%
    select(locus, sample,
           consensus_size_a0, consensus_size_a1,
           read_count_a0, read_count_a1) %>%
    mutate(across(everything(), suppressWarnings(as.numeric)))
  
  motif_diversity <- motif_diversity %>%
    left_join(add_sizes, by = c("locus", "sample")) %>%
    mutate(
      consensus_size = ifelse(allele == "0", consensus_size_a0, consensus_size_a1),
      read_count = ifelse(allele == "0", read_count_a0, read_count_a1)
    ) %>%
    select(locus, sample, allele, entropy, dominant_motif, dominant_fraction,
           n_motifs_present, consensus_size, read_count)
  
  motif_diversity
}
