#' Calculate AKI stage
#'
#' Calculate AKI class based on serum creatinine values over time, using various
#' methods for children (pRIFLE) and adults (RIFLE, kDIGO)
#'
#' @param scr serum creatinine in mg/dL. Use `convert_creat()` to convert from
#'   mmol/L. Values below the detection limit ("<0.2") will be converted to
#'   numeric (0.2)
#' @param times creatinine sample times in hours
#' @param method classification method, one of `KDIGO`, `RIFLE`, `pRIFLE` (case insensitive)
#' @param baseline_scr baseline serum creatinine, required for `RIFLE` classifation. Will use value if numeric. If `character`, can be either `median`, `median_before_treatment`, `lowest`, or `first`.
#' @param baseline_egfr baseline eGFR, required for `RIFLE` classifations. Will take median of `egfr` values if `NULL`.
#' @param first_dose_time time in hours of first dose relative to sCr value, used for calculate baseline serum creatinine in `median_before_treatment` approach.
#' @param override_prifle_baseline by default, `pRIFLE` compares eGFR to 120 ml/min. Override by setting to TRUE.
#' @param age age in years, needed when eGFR is used in the classification method
#' @param egfr eGFR in ml/min/1.73m^2. Optional, can also be calcualted if `age`, `weight`, `height`, `sex`, `egfr_method` are specified as arguments.
#' @param egfr_method eGFR calculation method, used by `calc_egfr()`. If NULL, will pick default based on classification system (`cockroft_gault` for RIFLE / kDIGO, `revised_schwartz` for pRIFLE).
#' @param force_numeric keep stage numeric (1, 2, or 3), instead of e.g. "R", "I", "F" as in RIFLE. Default `FALSE`.
#' @param return_object return object with detailed data (default `TRUE`). If `FALSE`, will just return maximum stage.
#' @param verbose verbose (`TRUE` or `FALSE`)
#' @param ... arguments passed on to `calc_egfr()`
#' @references \itemize{
#'   \item \href{https://pubmed.ncbi.nlm.nih.gov/17396113/}{pRIFLE}: Ackan-Arikan et al. "Modified RIFLE criteria in critically ill children with acute kidney injury." Kidney Int. (2007)
#'   \item \href{https://pubmed.ncbi.nlm.nih.gov/15312219/}{RIFLE}: Bellomo et al. "Acute renal failure - definition, outcome measures, animal models, fluid therapy and information technology needs: the Second International Consensus Conference of the Acute Dialysis Quality Initiative (ADQI) Group." Critical Care. (2004)
#'   \item \href{https://pubmed.ncbi.nlm.nih.gov/22890468/}{KDIGO}: Khwaja. "KDIGO clinical practice guidelines for acute kidney injury." Nephron Clinical Practice. (2012)
#'   \item \href{https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4238883/}{pRIFLE baseline eGFR}: Soler et al. "pRIFLE (Pediatric Risk, Injury, Failure, Loss, End Stage Renal Disease) score identifies Acute Kidney Injury and predicts mortality in critically ill children : a prospective study." Pediatric Critical Care Medicine. (2014)
#' }
#'
#' @examples
#' calc_aki_stage(
#'   scr = c(0.7, 0.9, 1.8, 1.5),
#'   t = c(0, 40, 100, 130),
#'   age = 50, weight = 60,
#'   height = 170, sex = "female")
#'
#' @export
calc_aki_stage <- function (
  scr = NULL,
  times = NULL,
  method = "kdigo",
  baseline_scr = "median",
  baseline_egfr = NULL,
  first_dose_time = NULL,
  age = NULL,
  egfr = NULL,
  egfr_method = NULL,
  force_numeric = FALSE,
  override_prifle_baseline = FALSE,
  verbose = TRUE,
  return_object = TRUE,
  ...
) {
  aki_detected <- FALSE
  aki_stage <- 0

  ## Checks
  available_methods <- c("rifle", "prifle", "kdigo")
  method <- tolower(method)
  if(!method %in% available_methods) {
    stop(paste0("AKI classification method not recognized, please select one from: ",
                paste(available_methods, collapse = " ")))
  }
  if(is.null(egfr_method)) {
    if(method == "prifle") {
      egfr_method <- "schwartz_revised"
    } else {
      egfr_method <- "cockroft_gault"
    }
  }
  
  ## Make sure values are ordered by time
  if(!is.null(times)) {
    idx   <- order(times)
    times <- times[idx]
    scr   <- scr[idx]
    egfr  <- egfr[idx]
  }

  if(is.null(scr) && method !='prifle') stop("No serum creatinine values provided.")
  if(is.null(times) && method !='prifle') stop("No sample times (days) provided.")
  if(inherits(times, "Date")) {
    times <- as.numeric(difftime(times, min(times), units = "days"))
  }
  if(!inherits(times[1], c("numeric","integer")) && method !='prifle') {
    stop("`times` argument should be supplied either as days (numeric) or as Date class.")
  }
  if(length(scr) != length(times) && method !='prifle') stop("Serum creatinine values and vector of sample times should have same length.")
  if(is.null(egfr)) {
    if(is.null(age)) stop("Also need age when eGFR is not provided as argument.")
  }
  if(!is.null(egfr)) {
    if(length(egfr) != length(scr) && method !='prifle') stop("Serum creatinine values and vector of eGFR values should have same length.")
  }

  scr <- remove_lt_gt(scr)   # handle case where scr is "<0.2"
  if (inherits(scr, "character")) {
    stop("Could not coerce SCr values to numeric")
  }
  if(is.null(baseline_scr)) {
    if(method %in% c("kdigo", "rifle")) { # scr not needed for pRIFLE
      stop("Need baseline scr value or method.")
    } else {
      baseline_scr <- 1 # dummy
    }
  }
  # pRIFLE does not require SCr
  if(inherits(baseline_scr, "character") && method !='prifle') {
    baseline_scr <- calc_baseline_scr(baseline_scr, 
                                      scr,
                                      times,
                                      method,
                                      first_dose_time,
                                      verbose)
  }
  if(method %in% ('prifle') && !(override_prifle_baseline)) baseline_egfr <- 120

  ## eGFR
  if(is.null(egfr)) {
    if(is.null(scr) & is.null(times)) {
      stop("Must supply eGFR or sufficient information to calculate eGFR")
    } else {
    egfr <- calc_egfr(
      scr = scr,
      times = times,
      method = egfr_method,
      age = age,
      verbose = verbose,
      relative = TRUE, # KDIGO requires relative eGFR value in Stage 3 condition; all other criteria use eGFR relative to baseline
      ...
    )$value
    }
  }

  ## Differences in SCr - don't need scr for pRIFLE
  if (method %in% c("kdigo", "rifle")) {
    dat <- data.frame(scr = scr, t = times, deltat = c(0, diff(times)), baseline_scr = baseline_scr)
    dat$baseline_scr_diff <- (dat$scr - baseline_scr)
    dat$baseline_scr_reldiff <- dat$baseline_scr_diff / baseline_scr
    dat$stage <- rep(NA, length(scr))
  } else {
    dat <- data.frame(stage = rep(NA, max(length(egfr), length(scr))))
    if(!is.null(times)) dat$t <- times
  }
  ## Differences in eGFR
  dat$egfr <- egfr
  if(is.null(baseline_egfr)) {
    baseline_egfr <- stats::median(egfr)
    if(verbose) warning("No baseline eGFR value specified, using median of supplied values.")
  }
  dat$baseline_egfr_diff <- (dat$egfr - baseline_egfr)
  dat$baseline_egfr_reldiff <- dat$baseline_egfr_diff / baseline_egfr

  if(method == "prifle") {
    dat$stage[dat$baseline_egfr_reldiff < -0.25] <- 1
    dat$stage[dat$baseline_egfr_reldiff < -0.5] <- 2
    dat$stage[dat$baseline_egfr_reldiff < -0.75 | dat$egfr < 35] <- 3
    
  } else if (method == "rifle") {
    dat$stage[dat$baseline_egfr_reldiff < -0.25 | dat$baseline_scr_reldiff >= 1.5] <- 1
    dat$stage[dat$baseline_egfr_reldiff < -0.50 | dat$baseline_scr_reldiff >= 2.0] <- 2
    dat$stage[dat$baseline_egfr_reldiff < -0.75 | dat$baseline_scr_reldiff >= 3.0] <- 3
    dat$stage[dat$baseline_scr_diff >= 0.5 | dat$scr >= 4.0] <- 3
    
  } else if (method == "kdigo") {
    dat$stage <- kdigo_stage(dat = dat, baseline_scr = baseline_scr, age = age)
  }

  ## get max class, convert to character class:
  if(all(is.na(dat$stage))) {
    stage <- NA
    t_max_stage <- NULL
  } else {
    stage <- max(dat$stage, na.rm = TRUE)
    t_max_stage <- dat$t[dat$stage == stage & !is.na(dat$stage)][1]
    if(!force_numeric) {
      if(method %in% c("rifle", "prifle")) {
        char_stages <- c("R", "I", "F")
      }
      if(method %in% c("kdigo")) {
        char_stages <- c("stage 1", "stage 2", "stage 3")
      }
      stage <- char_stages[stage]
    }
  }

  if(verbose) message("Please note: Urinary output is not taken into account in staging.")

  if(return_object) {
    obj <- list(
      stage = stage,
      time_max_stage = t_max_stage,
      data = dat,
      method = method
    )
  } else {
    obj <- stage
  }

  return(obj)
}

#' Calculate AKI stage according to KDIGO criteria
#'
#' @param dat Data frame containing at least the following columns:
#'  * `scr`: serum creatinine
#'  * `t`: creatinine sample times in hours
#'  * `baseline_scr_diff`: difference between baseline scr and scr at current
#'     timepoint
#'  * `egfr`: eGFR at timepoint
#' @param baseline_scr Baseline serum creatinine value (numeric)
#' @param age Patient age
#' @md
#' @keywords internal
kdigo_stage <- function(dat, baseline_scr, age) {
  stage <- rep(NA, nrow(dat))
  for (i in seq_along(dat$t)) {
    current_time <- dat$t[i]
    last_48h <- which(dat$t < current_time & dat$t > (current_time - 48))
    scr <- dat$scr[i]
    scr_last_48h <- dat$scr[last_48h]
    # An AKI has occurred if there's a rise by 0.3 mg/dl within 48 hours or if
    # there's a rise to 1.5x baseline*. We only check for the 0.3 mg/dl rise if
    # scr_last_48h contains at least one value, since otherwise we don't have
    # any prior timepoints to compare to.
    #
    # *technically the rise to 1.5x baseline should be "known or presumed to
    # have occurred within the prior 7 days", but that is a bit hard to pin
    # down and raises a lot of edge cases, so we do not implement that logic
    # here currently.
    if ((scr / baseline_scr) %>=% 1.5 || (length(scr_last_48h) > 0 && (scr - min(scr_last_48h)) %>=% 0.3)) {
      stage[i] <- 1
    }
    if ((scr / baseline_scr) %>=% 2) {
      stage[i] <- 2
    }
    if ((scr / baseline_scr) %>=% 3 || scr %>=% 4 || isTRUE(dat$egfr[i] < 35 & age < 18)) {
      stage[i] <- 3
    }
  }
  stage
}
