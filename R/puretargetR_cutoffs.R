# =====================================================================
# puretargetR_cutoffs.R
# puretargetR | Standard repeat count cutoffs for PureTarget 2.0 panel loci
# Author: Dias Lab (A. Dischler)
# =====================================================================

#' Retrieve standard repeat-size cutoffs for known repeat-expansion loci
#'
#' These cutoffs include established thresholds for:
#'   - normal range
#'   - intermediate or “gray zone”
#'   - premutation (if applicable)
#'   - pathogenic expansions
#'
#' The table also includes each locus’s inheritance model
#' (AD, AR, XLD, XLR, XD):
#'   - "AD": Autosomal dominant (one pathogenic allele sufficient)
#'   - "AR": Autosomal recessive (two pathogenic alleles required; one = carrier)
#'   - "XLD": X-linked dominant
#'   - "XLR": X-linked recessive (typically carrier in females, affected in males)
#'   - "XD": X-linked disorder with structured repeat ranges (e.g., FMR1)
#'
#' @return A tibble containing one row per locus with columns:
#'   locus, normal_max, intermediate_min, intermediate_max,
#'   premutation_min, pathogenic_min, inheritance
#'
#' @export
#'
puretargetR_cutoffs <- function() {

  tibble::tribble(
    ~locus, ~normal_max, ~intermediate_min, ~intermediate_max, ~premutation_min, ~pathogenic_min, ~inheritance,

    # Dominant SCAs
    "SCA1_ATXN1",     34, 35, 38, NA,  39, "AD",
    "SCA2_ATXN2",     31, 32, 33, NA,  34, "AD",
    "SCA3_ATXN3",     44, 45, 59, NA,  60, "AD",
    "SCA6_CACNA1A",   18, 19, 19, NA,  20, "AD",
    "SCA7_ATXN7",     36, 37, 44, NA,  45, "AD",
    "SCA17_TBP",      44, 45, 48, 49,  55, "AD",
    "DRPLA_ATN1",     35, 36, 48, NA,  49, "AD",
    "SCA8_ATXN8OS",   50, 51, 79, NA,  80, "AD",
    "SCA10_ATXN10",   32, 33, 849, NA, 850, "AD",
    "SCA12_PPP2R2B",  50, 51, 51, NA,  52, "AD",
    "SCA27B_FGF14",   40, 41, 299, NA, 300, "AD",
    "SCA31_BEAN1",    50, 51, 70, NA,  71, "AD",
    "SCA36_NOP56",   400, 401, 649, NA, 650, "AD",
    "SCA37_DAB1",     50, 51, 59, NA,  60, "AD",
    "SCA4_ZFHX3",     50, NA, NA, NA,  51, "AD",

    # Huntington family
    "HD_HTT",         26, 27, 35, 36,  40, "AD",
    "HDL2_JPH3",      28, 29, 40, NA,  41, "AD",
    "SBMA_AR",        35, 36, 37, NA,  38, "XLD",

    # Fragile X family
    "FXS_FMR1",       44, 45, 54, 55, 200, "XD",
    "FRAXE_AFF2",     44, 45, 199, NA, 200, "XLR",
    "FRA2A_AFF3",    200, NA, NA, NA, 300, "AD",

    # Recessive repeat diseases
    "FRDA_FXN",       33, 34, 65, NA,  66, "AR",
    "CANVAS_RFC1",   300, 301, 399, NA, 400, "AR",
    "EPM1_CSTB",      75, 76, 99, NA, 100, "AR",

    # AD but with reduced penetrance
    "NIID_NOTCH2NLC", 40, 41, 59, 60, 100, "AD",

    # Special cases
    "CCHS_PHOX2B",    20, 21, 23, NA,  24, "AD",

    # OPDM / OPMD family
    "OPMD_PABPN1",    10, 11, 12, NA,  13, "AD",
    "OPDM1_LRP12",   100, 101, 124, 125, 150, "AD",
    "OPDM2_GIPC1",   100, 101, 124, 125, 150, "AD",
    "OPDM4_RILPL1",  100, 101, 124, 125, 150, "AD"
  )
}
