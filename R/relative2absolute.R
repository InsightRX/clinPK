#' Convert quantity expressed relative to BSA to absolute units
#'
#' Often used for eGFR estimates
#'
#' @param quantity quantity expressed in units /1.73m2
#' @param bsa ideal body weight in kg
#' @param ... arguments passed on to `calc_bsa`, if bsa is NULL
#' @return quantity expressed in absolute units
#' @examples
#' relative2absolute_bsa(quantity = 60, bsa = 1.6)
#' relative2absolute_bsa(quantity = 60, weight = 14, height = 90, method = "dubois")
#' @export
relative2absolute_bsa <- function(quantity, bsa = NULL, ...) {
  if(is.null(bsa)) {
    bsa <- calc_bsa(...)$value
  }
  list(
    value = quantity * bsa / 1.73
  )
}
