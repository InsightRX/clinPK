#' Convert any weight unit to kg
#'
#' @param value weight in any allowed unit
#' @param unit unit of weight, one of "lb", "lbs", "pound", "pounds", "oz", "ounce", "ounces", "g", "gram", "grams"
#' @examples
#' weight2kg(250, unit = "oz")
#' weight2kg(250, unit = "pounds")
#' weight2kg(250, unit = "lbs")
#' @export
weight2kg <- function(value = NULL, unit = NULL) {
  if(is.null(value)) {
    stop("No weight value specified.")
  }
  if(!is.null(unit) && !any(is.na(unit))) {
    if(all(tolower(unit) %in% valid_units("weight"))) {
      div <- vector(mode = "numeric", length = length(unit))
      div[which(tolower(unit) %in% c("lb", "lbs", "pound", "pounds"))] <- 2.20462
      div[which(tolower(unit) %in% c("oz", "ounce", "ounces"))] <- 35.274
      div[which(tolower(unit) %in% c("g", "gram", "grams"))] <- 1000
      div[which(tolower(unit) %in% c("kg"))] <- 1

      value <- value / div
    } else {
      invalid <- setdiff(unit, valid_units("weight"))
      stop(paste0("Unit(s) (", paste0(invalid, collapse = ", "), ") not recognized."))
    }
  } else {
    stop("Weight unit not specified.")
  }
  return(value)
}
