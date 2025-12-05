# ==================================================================
# puretargetR | Load all core functions from GitHub
# Author: Dias Lab (A. Dischler)
# ==================================================================

# Usage:
# devtools::source_url("https://raw.githubusercontent.com/annadish/puretargetR/main/R/load_pipeline.R")
# load_puretargetR_pipeline()

load_puretargetR_pipeline <- function(branch = "main") {
  
  if (!requireNamespace("devtools", quietly = TRUE)) {
    stop("The 'devtools' package is required. Please install it:\ninstall.packages('devtools')")
  }
  
  base <- paste0(
    "https://raw.githubusercontent.com/annadish/puretargetR/",
    branch, "/R/"
  )
  
  # ---------------------------------------------------------------
  # Core preprocessing functions
  # ---------------------------------------------------------------
  preprocess_scripts <- c(
    "make_summary_wide.R",
    "make_repeat_summary.R",
    "make_motif_per_sample.R",
    "make_motif_presence.R",
    "make_diversity.R"
  )
  
  # ---------------------------------------------------------------
  # NEW: Classification + Cohort Summary modules
  # ---------------------------------------------------------------
  classifier_scripts <- c(
    "puretargetR_cutoffs.R",
    "classify_motif.R",
    "classify_inheritance.R",
    "classify_expansions.R",
    "summarize_cohort.R",
    "summarize_locus_expansions.R"  # optional helper
  )
  
  all_scripts <- c(preprocess_scripts, classifier_scripts)
  
  # ---------------------------------------------------------------
  # Load each script from GitHub
  # ---------------------------------------------------------------
  for (f in all_scripts) {
    message("Sourcing ", f, " ...")
    devtools::source_url(paste0(base, f))
  }
  
  message("\n✔ puretargetR pipeline successfully loaded.")
  message("   Available functions:")
  message("   - make_repeat_summary()")
  message("   - make_summary_wide()")
  message("   - make_motif_per_sample()")
  message("   - make_motif_presence()")
  message("   - make_diversity()")
  message("   - classify_motif()")
  message("   - classify_inheritance()")
  message("   - classify_expansions()  <-- MAIN ENTRYPOINT")
  message("   - summarize_cohort()")
  message("   - summarize_locus_expansions()")
}

