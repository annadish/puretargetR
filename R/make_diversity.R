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
      .groups = "drop"
    )
  
  # Make sure `locus` matches in type
  motif_diversity <- motif_diversity %>% mutate(locus = as.character(locus))
  df_summary_wide  <- df_summary_wide %>% mutate(locus = as.character(locus))
  
  # Attach consensus sizes by allele
  add_sizes <- df_summary_wide %>%
    select(locus, sample, consensus_size_a0, consensus_size_a1)
  
  motif_diversity_sizes <- motif_diversity %>%
    left_join(add_sizes, by = c("locus", "sample")) %>%
    mutate(
      consensus_size = ifelse(
        allele == "0",
        as.numeric(consensus_size_a0),
        as.numeric(consensus_size_a1)
      )
    )
  
  motif_diversity_sizes
}
