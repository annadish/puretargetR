#' Reshape PureTarget report from wide to long format
#' @param raw_df A wide-format dataframe (e.g. directly read from a PureTarget CSV)
#' @return A tidy long-format dataframe with columns:
#'   Locus, Feature, Type, Allele, Dataset, Genotype, Value, Value_num
#' @examples
#' re_long <- reshape_re_long(re_2.0_48plex)
#' head(re_long)

reshape_re_long <- function(raw_df) {
  message("Reshaping PureTarget report...")

  # Identify dataset name if available
  dataset_name <- if ("Dataset" %in% names(raw_df)) unique(raw_df$Dataset) else "unknown_dataset"

  # Convert from wide to long format
  re_long <- raw_df %>%
    pivot_longer(
      cols = matches("^R2_GV"),  # all genotype columns (R2_GV-01, etc.)
      names_to = "Genotype",
      values_to = "Value"
    ) %>%
    separate(
      Sample,
      into = c("Locus", "Feature", "Type", "Allele"),
      sep = " ",
      fill = "right",
      remove = FALSE
    ) %>%
    mutate(
      Dataset = dataset_name,
      Feature_full = paste(Feature, Type, Allele),
      Value_num = suppressWarnings(as.numeric(Value))
    )

  message("✅ Reshape complete! Rows: ", nrow(re_long))
  return(re_long)
}
