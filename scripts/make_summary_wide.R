#'
#' Converts long-format repeat expansion data into a wide summary table
#' (one row per sample × locus), with standardized column names.
#'
#' @param df_long_clean A long-format tibble containing columns
#' @return A tibble with one row per sample/locus, and columns for each feature type.
#' @examples
#' df_summary_wide <- make_summary_wide(df_long_clean)
#' @export

make_summary_wide <- function(df_long_clean) {
  df_summary_wide <- df_long_clean %>%
    mutate(
      Feature_label = ifelse(
        is.na(Allele),
        Feature_class,
        paste0(Feature_class, " allele", Allele)
      )
    ) %>%
    select(Locus, Sample_ID, Feature_label, Value) %>%
    distinct() %>%
    pivot_wider(names_from = Feature_label, values_from = Value) %>%
    janitor::clean_names() %>%
    rename(
      sample = sample_id,
      repeat_unit = repeat_unit,
      read_count_a0 = read_count_allele0,
      read_count_a1 = read_count_allele1,
      consensus_size_a0 = consensus_size_allele0,
      consensus_size_a1 = consensus_size_allele1
    ) %>%
    relocate(locus, sample)
  
  df_summary_wide
}
