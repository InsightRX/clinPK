#' Generic function to calculate the dose nearest to a specific dose unit increment
#'
#' @param dose dose value
#' @param increment available increments of dose
#' @param type how to round, one of `round`, `floor`, or `ceiling`
#' @examples
#' find_nearest_dose(573)
#' find_nearest_dose(573, increment = 50)
#' @export
find_nearest_dose <- function(dose = NULL, increment = 250, type = "round") {
  if (is.null(dose)) {
    stop("Dose value required!")
  }
  if (is.null(increment)) {
    stop("increment cannot be NULL")
  }
  if (!type %in% c("round", "floor", "ceiling")) {
    stop("`type` must be one of 'round', 'floor', or 'ceiling'.")
  }

  switch(
    type,
    round = round(dose / increment) * increment,
    floor = floor(dose / increment) * increment,
    ceiling = ceiling(dose / increment) * increment
  )
}
