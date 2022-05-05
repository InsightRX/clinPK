#' Calculate baseline sCr
#' 
#' @inheritParams calc_aki_stage
#' @param baseline_scr baseline serum creatinine method (character). See calc_aki_stage() for availabloptions.
#' 
#' @export
calc_baseline_scr <- function(
  baseline_scr, 
  scr,
  times,
  method,
  first_dose_time = NULL,
  verbose) {
  if(baseline_scr == "median_before_treatment") {
    if(is.null(first_dose_time)) {
      baseline_scr <- stats::median(scr, na.rm = TRUE)
      if(verbose) message("To calculate median baseline before treatment start need time of first dose. Using median over whole treatment period.")
    } else {
      if((!inherits(first_dose_time, c("numeric","integer")))) {
        stop("`first_dose_times` argument should be supplied as numeric (hours).")
      }
      if(any(times <= first_dose_time)) {
        baseline_scr <- stats::median(scr[times <= first_dose_time], na.rm = TRUE)
        if(verbose) message("No baseline SCr value specified, using *median* of supplied values before first dose.")
      } else {
        if(any(times < 48)) {
          baseline_scr <- stats::median(scr[times < 48], na.rm = TRUE)
          if(verbose) message("No baseline before first dose, using *median* of supplied values in first 48 hours.")
        } else {
          baseline_scr <- stats::median(scr, na.rm = TRUE)
          if(verbose) message("No baseline in first 48 hours, using *median* of supplied values.")
        }
      }
    }
  }
  if(baseline_scr == "median") {
    baseline_scr <- stats::median(scr)
    if(verbose) message("No baseline SCr value specified, using *median* of supplied values.")
  }
  if(baseline_scr == "first" && method !='prifle') {
    baseline_scr <- scr[1]
    if(verbose) message("No baseline SCr value specified, using *first* of supplied values.")
  }
  if(baseline_scr == "lowest") {
    baseline_scr <- min(scr)
    if(verbose) message("No baseline SCr value specified, using *lowest* of supplied values.")
  }
  if(baseline_scr == "expected" && method !='prifle') {
    ## TODO: need to implement
  }
  if(! inherits(baseline_scr, c("numeric", "integer"))) {
    stop("Requested baseline calculation method not recognized.")
  }
  
  baseline_scr
}
