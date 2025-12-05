#' Compute cohort-level motif presence and frequency summaries
#'
#' This function takes the long-format motif table produced by
#' `make_motif_per_sample()` and summarizes how often each motif occurs
#' across samples, both overall and per allele. It also constructs a
#' wide-format allele comparison table and identifies rare motifs and
#' the samples that carry them.
#'
#' @param motif_freq_individual A tibble containing at least the columns:
#'   \code{locus}, \code{sample}, \code{allele}, \code{motif}, \code{proportion}.
#'   This is the output \code{$motif_freq_individual} from `make_motif_per_sample()`.
#'
#' @return A list of four tibbles:
#'   \item{\code{motif_presence}}{Motif presence frequency per locus (sample-level).}
#'   \item{\code{motif_presence_by_allele}}{Motif presence frequency per allele (0/1).}
#'   \item{\code{motif_freq_wide}}{Wide-format table comparing allele_0 vs allele_1 frequencies.}
#'   \item{\code{rare_motif_samples}}{Sorted list of motifs with the samples in which they occur.}
#'
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
