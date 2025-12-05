#' Expand allele-level repeat-unit strings into per-motif counts
#'
#' This function takes the wide-format table produced by `make_summary_wide()`
#' and expands each allele into a long-form table listing every motif and its
#' corresponding count. TRGT often reports multiple motif types per allele
#' (e.g. AAAGG and AAGGG), and this function harmonizes motif and count
#' vectors to ensure they remain aligned.
#'
#' The output includes:
#'   • `motif_counts_long` — one row per sample × locus × allele × motif
#'       (with raw motif counts)
#'   • `motif_freq_individual` — same structure but with per-allele proportions
#'
#' This table is the backbone for motif diversity analysis and motif
#' presence/absence matrices.
#'
#' @param df_summary_wide A tibble from `make_summary_wide()` containing:
#'   locus, sample, repeat_unit, motif_counts_allele0, motif_counts_allele1
#'
#' @return A list with:
#'   - motif_counts_long: long-format motif counts
#'   - motif_freq_individual: long-format motif proportions
#'
#' @export

make_motif_per_sample <- function(df_summary_wide) {
  
  df <- df_summary_wide %>%
    select(locus, sample, repeat_unit,
           motif_counts_allele0, motif_counts_allele1)
  
  motif_long <- df %>%
    pivot_longer(
      cols = starts_with("motif_counts_"),
      names_to = "allele",
      values_to = "motif_counts"
    ) %>%
    mutate(
      allele = str_extract(allele, "\\d+"),
      motifs = str_split(repeat_unit, ":+"),
      counts = map(motif_counts, split_counts),
      len_motifs = map_int(motifs, length),
      len_counts = map_int(counts, length),
      k = pmin(len_motifs, len_counts),
      motifs = map2(motifs, k, ~ .x[seq_len(.y)]),
      counts = map2(counts, k, ~ .x[seq_len(.y)])
    ) %>%
    transmute(
      locus, sample, allele,
      data = map2(motifs, counts, ~ tibble(motif = .x, count = .y))
    ) %>%
    unnest(data) %>%
    mutate(count = replace_na(count, 0))
  
  motif_freq_individual <- motif_long %>%
    group_by(locus, sample, allele) %>%
    mutate(
      total_count = sum(count, na.rm = TRUE),
      proportion = ifelse(total_count > 0, count / total_count, 0)
    ) %>%
    ungroup()
  
  list(
    motif_counts_long = motif_long,
    motif_freq_individual = motif_freq_individual
  )
}
