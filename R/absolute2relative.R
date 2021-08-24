#' Convert quantity expressed in absolute units relative to normalized BSA
#'
#' Often used for eGFR estimates
#'
#' @param quantity quantity expressed in absolute units
#' @param bsa ideal body weight in kg
#' @param ... arguments passed on to `calc_bsa`, if bsa is NULL
#' @return quantity expressed relative to /1.73m2
#' @examples
#' absolute2relative_bsa(quantity = 60, bsa = 1.6)
#' absolute2relative_bsa(quantity = 60, weight = 14, height = 90, method = "dubois")
#' @export
absolute2relative_bsa <- function(quantity, bsa = NULL, ...) {
  if(is.null(bsa)) {
    bsa <- calc_bsa(...)$value
  }
  list(
    value = quantity * 1.73 / bsa
  )
}
