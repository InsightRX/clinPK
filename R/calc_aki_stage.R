#' Calculate AKI stage
#'
#' Calculate AKI class based on serum creatinine values over time, using various
#' methods for children (pRIFLE) and adults (RIFLE, kDIGO)
#'
#' @param scr serum creatinine in mg/dL. Use `convert_creat()` to convert from mmol/L.
#' @param times creatinine sample times in hours
#' @param method classification method, one of `KDIGO`, `AKIN`, `RIFLE`, `pRIFLE`
#' @param baseline_scr baseline serum creatinine, required for `RIFLE` classifation. Will take median of `scr` values if `NULL`.
#' @param baseline_egfr baseline eGFR, required for `AKIN`, `RIFLE`, and `pRIFLE` classifations. Will take median of `egfr` values if `NULL`.
#' @param age age in years, needed when eGFR is used in the classification method
#' @param egfr eGFR in ml/min/1.73m^2. Optional, can also be calcualted if `age`, `weight`, `height`, `sex`, `egfr_method` are specified as arguments.
#' @param egfr_method eGFR calculation method, used by `calc_egfr()`
#' @param force_numeric keep stage numeric (1, 2, or 3), instead of e.g. "R", "I", "F" as in RIFLE. Default `FALSE`.
#' @param recursive option for KDIGO classification method only. Use recursive calculation (if `FALSE` will only take last observation into account)
#' @param return_object return object with detailed data (default `TRUE`). If `FALSE`, will just return maximum stage.
#' @param verbose verbose (`TRUE` or `FALSE`)
#' @param ... arguments passed on to `calc_egfr()`
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
  method = "kDIGO",
  baseline_scr = NULL,
  baseline_egfr = NULL,
  age = NULL,
  egfr = NULL,
  egfr_method = "cockcroft_gault",
  force_numeric = FALSE,
  recursive = TRUE,
  verbose = TRUE,
  return_object = TRUE,
  ...
) {
  aki_detected <- FALSE
  aki_stage <- 0

  ## Checks
  if(is.null(scr)) stop("No serum creatinine values provided.")
  if(is.null(times)) stop("No sample times (days) provided.")
  if(class(times) == "Date") {
    times <- times[order(times)]
    times <- as.numeric(difftime(times, min(times), units = "days"))
  }
  if(!class(times[1]) %in% c("numeric","integer")) {
    stop("`times` argument should be supplied either as days (numeric) or as Date class.")
  }
  if(length(scr) != length(times)) stop("Serum creatinine values and vector of sample times should have same length.")
  if(is.null(egfr)) {
    if(is.null(age)) stop("Also need age when eGFR is not provided as argument.")
  }
  if(!is.null(egfr)) {
    if(length(egfr) != length(scr)) stop("Serum creatinine values and vector of eGFR values should have same length.")
  }

  available_methods <- c("RIFLE", "pRIFLE", "kDIGO")
  if(!tolower(method) %in% tolower(available_methods)) {
    stop(paste0("AKI classification method not recognized, please select one from: ",
                paste(available_methods, collapse = " ")))
  }

  if(is.null(baseline_scr)) {
    baseline_scr <- stats::median(scr)
    if(verbose) warning("No baseline SCr value specified, using median of supplied values.")
  }

  ## Differences
  dat <- data.frame(scr = scr, t = times, deltat = c(0, diff(times)))
  dat$baseline_scr_diff <- (dat$scr - baseline_scr)
  dat$baseline_scr_reldiff <- dat$baseline_scr_diff / baseline_scr
  dat$stage <- NA

  ## eGFR
  if(is.null(egfr)) {
    egfr <- calc_egfr(
      scr = scr,
      times = times,
      method = egfr_method,
      age = age,
      ...
    )$value
  }
  dat$egfr <- egfr
  if(is.null(baseline_egfr)) {
    baseline_egfr <- stats::median(egfr)
    if(verbose) warning("No baseline eGFR value specified, using median of supplied values.")
  }
  dat$baseline_egfr_diff <- (dat$egfr - baseline_egfr)
  dat$baseline_egfr_reldiff <- dat$baseline_egfr_diff / baseline_egfr

  if(tolower(method) %in% c("rifle", "prifle")) {
      dat$stage[dat$baseline_egfr_reldiff < -0.25] <- 1
      if(method == "rifle") dat$stage[dat$baseline_scr_reldiff > 1.5] <- 1
      dat$stage[dat$baseline_egfr_reldiff < -0.5] <- 2
      if(method == "rifle") dat$stage[dat$baseline_scr_reldiff > 2.0] <- 2
      dat$stage[dat$baseline_egfr_reldiff < -0.75 | dat$egfr < 35] <- 3
      if(method == "rifle") dat$stage[dat$baseline_scr_reldiff > 3.0] <- 3
      if(method == "rifle") dat$stage[dat$scr > 4.0 && max(diff(dat$scr) > 0.5)] <- 3
  }

  if(tolower(method) == "kdigo") {
    dat$stage[dat$baseline_scr_reldiff > 1.5 | dat$baseline_scr_diff > 0.3] <- 1
    dat$stage[dat$baseline_scr_reldiff > 2.0 | dat$baseline_scr_diff > 0.5] <- 2
    dat$stage[dat$baseline_scr_reldiff > 3.0 | dat$scr >= 4.0 | (dat$egfr < 35 & age < 18)] <- 3
  }

  ## get max class, convert to character class:
  if(all(is.na(dat$stage))) {
    stage <- NA
    t_max_stage <- NULL
  } else {
    stage <- max(dat$stage, na.rm = TRUE)
    t_max_stage <- dat$t[dat$stage == stage & !is.na(dat$stage)][1]
    if(!force_numeric) {
      if(tolower(method) %in% c("rifle", "prifle")) {
        char_stages <- c("R", "I", "F")
      }
      if(tolower(method) %in% c("kdigo")) {
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
