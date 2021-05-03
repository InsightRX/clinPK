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
  stopifnot(
    "Dose value required!" = !is.null(dose),
    "increment cannot be NULL" = !is.null(increment),
    "`type` must be one of 'round', 'floor', or 'ceiling'." =
      type %in% c("round", "floor", "ceiling")
  )
  return(
    switch(
      type,
      round = round(dose / increment) * increment,
      floor = floor(dose / increment) * increment,
      ceiling = ceiling(dose / increment) * increment
    )
  )
}
