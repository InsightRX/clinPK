#' Convert inch to cm
#'
#' @param inch vector
#' @export
inch2cm <- function(inch) {
  return(inch*2.54)
}

#' Convert cm to inch
#'
#' @param cm vector
#' @export
cm2inch <- function(cm) {
 return(cm/2.54)
}

#' Convert kg to lbs
#'
#' @param kg vector
#' @export
kg2lbs <- function(kg) {
  return(kg*2.20462)
}

#' Convert lbs to kg
#'
#' @param lbs vector
#' @export
lbs2kg <- function(lbs) {
 return(lbs/2.20462)
}
