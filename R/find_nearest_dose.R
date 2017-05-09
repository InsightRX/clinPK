#' Generic function to calculate the dose nearest to a specific dose unit increment
#'
#' @param dose dose value
#' @param increment available increments of dose
#' @param type how to round, one of `round`, `floor`, or `ceiling`
#' @export
find_nearest_dose <- function(dose = NULL, increment = 250, type="round") {
  if(!is.null(dose)) {
    if(type %in% c("round", "floor", "ceiling")) {
      if(type == "round") {
        return(round(dose / increment) * increment)
      }
      if(type == "floor") {
        return(floor(dose / increment) * increment)
      }
      if(type == "ceiling") {
        return(ceiling(dose / increment) * increment)
      }
    }
  } else {
    stop("Dose value required!")
  }
}
