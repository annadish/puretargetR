#' Summarizes motif occurrence and frequency across samples and alleles.
#'
#' @param motif_freq_individual Tibble containing columns locus, sample, allele, motif, proportion.
#' @return A list of four tibbles:
#'   \itemize{
#'     \item motif_presence - overall motif frequencies (sample-level)
#'     \item motif_presence_by_allele - per-allele motif frequencies
#'     \item motif_freq_wide - allele comparison (wide format)
#'     \item rare_motif_samples - list of samples carrying rare motifs
#'   }
#' @export

make_motif_presence <- function(motif_freq_individual) {
  motif_presence <- motif_freq_individual %>%
    filter(proportion > 0) %>%
    distinct(locus, motif, sample) %>%
    group_by(locus, motif) %>%
    summarise(
      n_present = n_distinct(sample),
      n_total = n_distinct(motif_freq_individual$sample),
      freq_present = n_present / n_total,
      .groups = "drop"
    )

  motif_presence_by_allele <- motif_freq_individual %>%
    filter(proportion > 0) %>%
    group_by(locus, motif, allele) %>%
    summarise(
      n_present = n_distinct(sample),
      n_total = n_distinct(motif_freq_individual$sample),
      freq_present = n_present / n_total,
      .groups = "drop"
    )

  motif_freq_wide <- motif_presence_by_allele %>%
    select(locus, motif, allele, freq_present) %>%
    pivot_wider(
      names_from = allele,
      values_from = freq_present,
      names_prefix = "allele_",
      values_fill = 0
    )

  rare_motif_samples <- motif_freq_individual %>%
    filter(proportion > 0) %>%
    distinct(locus, motif, sample) %>%
    add_count(locus, motif, name = "n_present") %>%
    group_by(locus, motif) %>%
    summarise(
      n_present = first(n_present),
      samples_present = paste(sort(unique(sample)), collapse = ", "),
      .groups = "drop"
    ) %>%
    arrange(n_present)

  list(
    motif_presence = motif_presence,
    motif_presence_by_allele = motif_presence_by_allele,
    motif_freq_wide = motif_freq_wide,
    rare_motif_samples = rare_motif_samples
  )
}
