#' make_repeat_summary
#'
#' Converts wide summary data into an allele-level repeat summary table.
#'
#' @param df_summary_wide Tibble with per-sample repeat info (output of make_summary_wide).
#' @return Tibble with one row per locus × sample × allele.
#' @export

make_repeat_summary <- function(df_summary_wide) {
  loci <- unique(df_summary_wide$locus)

  all_loci_summary <- loci %>%
    purrr::map_df(~{
      message("Processing ", .x, " ...")
      df_locus <- df_summary_wide %>% dplyr::filter(locus == .x)
      
      tibble(
        Locus = .x,
        RepeatUnit = df_locus$repeat_unit[1],
        Mean_Consensus_A0 = mean(as.numeric(df_locus$consensus_size_a0), na.rm = TRUE),
        Mean_Consensus_A1 = mean(as.numeric(df_locus$consensus_size_a1), na.rm = TRUE),
        Mean_ReadCount_A0 = mean(as.numeric(df_locus$read_count_a0), na.rm = TRUE),
        Mean_ReadCount_A1 = mean(as.numeric(df_locus$read_count_a1), na.rm = TRUE)
      )
    })

  all_loci_summary
}
