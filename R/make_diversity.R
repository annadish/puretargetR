#' Compute per-allele motif diversity metrics
#'
#' This function summarizes motif composition for each sample × locus × allele
#' using Shannon entropy and dominant-motif identification. It also attaches the
#' consensus repeat size for the corresponding allele from `df_summary_wide`,
#' enabling downstream analyses of how motif diversity relates to expansion size.
#'
#' @param motif_freq_individual A tibble produced by `make_motif_per_sample()`
#'   containing columns: locus, sample, allele, motif, proportion.
#' @param df_summary_wide A tibble from `make_summary_wide()` containing
#'   numeric columns `consensus_size_a0` and `consensus_size_a1`.
#'
#' @return A tibble with one row per sample × locus × allele containing:
#'   \itemize{
#'     \item \code{entropy} — Shannon entropy of motif proportions
#'     \item \code{dominant_motif} — motif with highest proportion
#'     \item \code{dominant_fraction} — fraction of total represented by dominant motif
#'     \item \code{consensus_size} — allele-specific consensus repeat size
#'   }
#'
#' @export

make_diversity <- function(motif_freq_individual, df_summary_wide) {

  motif_diversity <- motif_freq_individual %>%
    group_by(locus, sample, allele) %>%
    summarise(
      entropy = shannon_entropy(proportion),
      dominant_motif = motif[which.max(proportion)],
      dominant_fraction = max(proportion, na.rm = TRUE),
      richness = n_distinct(motif[proportion > 0]),
      hill_number = 1 / sum(proportion^2, na.rm = TRUE),
      .groups = "drop"
    )

  motif_diversity <- motif_diversity %>%
    mutate(
      entropy = ifelse(is.nan(entropy), 0, entropy)
    )

  df_summary_wide <- df_summary_wide %>% mutate(locus = as.character(locus))

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
