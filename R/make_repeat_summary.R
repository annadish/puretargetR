#' Summarize repeat-length statistics per locus
#'
#' This function collapses the wide-format table produced by
#' `make_summary_wide()` into a locus-level summary of consensus sizes
#' and read depths across all samples. It reports mean repeat size for
#' each allele, mean read depth per allele, and optionally min/max
#' values depending on the implementation.
#'
#' @param df_summary_wide Tibble containing allele-level repeat summaries
#'   (output of `make_summary_wide()`).
#'
#' @return A tibble where each row corresponds to one locus and includes:
#'   \itemize{
#'     \item \code{RepeatUnit} — the observed repeat-unit string
#'     \item \code{Mean_Consensus_A0}, \code{Mean_Consensus_A1}
#'     \item \code{Mean_Read_A0}, \code{Mean_Read_A1}
#'     \item Optional variability metrics (SD, min/max)
#'   }
#'
#' @export

make_repeat_summary <- function(df_summary_wide) {

  df_summary_wide %>%
    mutate(
      Consensus_A0 = as.numeric(consensus_size_a0),
      Consensus_A1 = as.numeric(consensus_size_a1),
      Read_A0 = as.numeric(read_count_a0),
      Read_A1 = as.numeric(read_count_a1)
    ) %>%
    group_by(locus) %>%
    summarise(
      RepeatUnit = first(repeat_unit),
      
      # Sample counts
      n_samples = n(),
      
      # Consensus size statistics
      Mean_Consensus_A0 = mean(Consensus_A0, na.rm = TRUE),
      SD_Consensus_A0 = sd(Consensus_A0, na.rm = TRUE),
      Mean_Consensus_A1 = mean(Consensus_A1, na.rm = TRUE),
      SD_Consensus_A1 = sd(Consensus_A1, na.rm = TRUE),

      # Read depth statistics
      Mean_Read_A0 = mean(Read_A0, na.rm = TRUE),
      Mean_Read_A1 = mean(Read_A1, na.rm = TRUE),
      
      # Min/max
      Min_Consensus = min(c(Consensus_A0, Consensus_A1), na.rm = TRUE),
      Max_Consensus = max(c(Consensus_A0, Consensus_A1), na.rm = TRUE),

      .groups = "drop"
    )
}
