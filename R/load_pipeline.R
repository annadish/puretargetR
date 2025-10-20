# ===============================================================
# puretargetR | Load all core functions from GitHub
# Author: Dias Lab (A. Dischler)
# ===============================================================

# You can call this file directly from GitHub using:
# devtools::source_url("https://raw.githubusercontent.com/annadish/puretargetR/main/R/load_pipeline.R")

load_puretargetR_pipeline <- function(branch = "main") {
  base <- paste0(
    "https://raw.githubusercontent.com/annadish/puretargetR/",
    branch, "/R/"
  )
  
  scripts <- c(
    "make_summary_wide.R",
    "make_repeat_summary.R",
    "make_motif_per_sample.R",
    "make_motif_presence.R",
    "make_diversity.R"
    # "make_panels.R"  # uncomment when ready
  )
  
  for (f in scripts) {
    message("Sourcing ", f, " ...")
    devtools::source_url(paste0(base, f))
  }
  
  message("puretargetR functions loaded successfully.")
}
