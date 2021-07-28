#' Calculate adjusted body weight (ABW)
#'
#' Often used for chemotherapy calculations when actual weight > 120% of IBW.
#' Adjusted body weight is returned in units of kg.
#'
#' @param weight actual body weight in kg
#' @param ibw ideal body weight in kg
#' @param verbose show output?
#' @param factor weighting factor, commonly 0.4 or 0.3
#' @param ... parameters passed to ibw function (if `ibw` not specified)
#' @return adjusted body weight in kg
#' @examples
#' calc_abw(weight = 80, ibw = 60)
#' calc_abw(weight = 80, height = 160, sex = "male", age = 60)
#' @export
calc_abw <- function(weight = NULL, ibw = NULL, factor = 0.4, verbose = TRUE, ...) {
  if(is.null(weight)) {
    stop("Weight needs to be specified!")
  }
  if(is.null(ibw)) {
    if(verbose) {
      message("Note: IBW not specified, trying to calculate from other parameters.")
    }
    ibw <- calc_ibw(...)
  }
  if(is.null(ibw)) {
    stop("IBW required for calculation of ABW.")
  }
  abw <- ibw + (weight-ibw) * factor
  return(abw)
}
