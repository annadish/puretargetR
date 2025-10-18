#' Summarize PureTarget locus data
#' @param df Long-format dataframe (e.g. re_long)
#' @param locus_name The locus to summarize (e.g. "SCA37_DAB1")
#' @return Tibble with dominant motifs and repeat totals per allele
#' @export

function(df, locus_name) {
  message("Processing ", locus_name, " ...")

  df_locus <- df %>% filter(Locus == locus_name)

  # 1️⃣ Extract repeat unit sequence
  repeat_unit <- df_locus %>%
    filter(Feature == "repeat") %>%
    distinct(Value) %>%
    pull(Value) %>%
    unique() %>%
    paste(collapse = ":")

  # 2️⃣ Pull motif count info and pivot by allele
  motif_counts <- df_locus %>%
    filter(Feature == "motif", Type == "counts") %>%
    select(any_of(c("Genotype", "genotype", "Sample", "Dataset", "dataset")), Allele, Value) %>%
    pivot_wider(names_from = Allele, values_from = Value,
                names_prefix = "motif_counts_") %>%
    janitor::clean_names()

  # \ud83d\udd0d identify key columns
  genotype_col <- names(motif_counts)[str_detect(names(motif_counts), "genotype")]
  motif0_col <- names(motif_counts)[str_detect(names(motif_counts), "motif_counts_.*0")]
  motif1_col <- names(motif_counts)[str_detect(names(motif_counts), "motif_counts_.*1")]

  if (length(genotype_col) == 0)
    stop("Could not find genotype/sample column after pivot_wider()")

  # 3️⃣ Compute profiles per genotype
  result <- motif_counts %>%
    rowwise() %>%
    mutate(
      motifs  = list(str_split(repeat_unit, ":")[[1]]),
      counts0 = list(as.numeric(str_split(.data[[motif0_col]], "\\.")[[1]])),
      counts1 = list(as.numeric(str_split(.data[[motif1_col]], "\\.")[[1]])),
      allele0_profile = list(tibble(motif = motifs[[1]], count = counts0[[1]])),
      allele1_profile = list(tibble(motif = motifs[[1]], count = counts1[[1]])),

      dominant_motif_allele0 = {
        x <- allele0_profile
        if (is.data.frame(x)) {
          m <- x %>% filter(count == max(count, na.rm = TRUE))
          paste(unique(m$motif), collapse = ";")
        } else NA_character_
      },
      dominant_motif_allele1 = {
        x <- allele1_profile
        if (is.data.frame(x)) {
          m <- x %>% filter(count == max(count, na.rm = TRUE))
          paste(unique(m$motif), collapse = ";")
        } else NA_character_
      },
      total_repeats_allele0 = if (is.data.frame(allele0_profile))
        sum(allele0_profile$count, na.rm = TRUE)
      else NA_real_,
      total_repeats_allele1 = if (is.data.frame(allele1_profile))
        sum(allele1_profile$count, na.rm = TRUE)
      else NA_real_
    ) %>%
    ungroup()

  # 4️⃣ Return clean summary
  result %>%
    rename(Genotype = all_of(genotype_col)) %>%
    mutate(Locus = locus_name) %>%
    select(Locus, Genotype,
           dominant_motif_allele0, total_repeats_allele0,
           dominant_motif_allele1, total_repeats_allele1)
}
