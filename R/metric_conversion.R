#' Convert inch to cm
#'
#' @param inch vector
#' @examples
#' inch2cm(1)
#' @export
inch2cm <- function(inch) {
  return(inch*2.54)
}

#' Convert cm to inch
#'
#' @param cm vector
#' @examples
#' cm2inch(2.54)
#' @export
cm2inch <- function(cm) {
 return(cm/2.54)
}

#' Convert kg to lbs
#'
#' @param kg vector
#' @examples
#' kg2lbs(1)
#' @export
kg2lbs <- function(kg) {
  return(kg*2.20462)
}

#' Convert lbs to kg
#'
#' @param lbs vector
#' @examples
#' lbs2kg(2.20462)
#' @export
lbs2kg <- function(lbs) {
 return(lbs/2.20462)
}

#' Convert kg to oz
#'
#' @param kg vector
#' @examples
#' kg2oz(1)
#' @export
kg2oz <- function(kg) {
  return(kg*35.274)
}

#' Convert oz to kg
#'
#' @param oz vector
#' @examples
#' oz2kg(2.20462)
#' @export
oz2kg <- function(oz) {
  return(oz/35.274)
}
