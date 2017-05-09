#' Convert any weight unit to kg
#'
#' @param value weight in any allowed unit
#' @param unit unit of weight, one of "lbs", "pound", "pounds", "oz", "ounce", "ounces"
#' @export
weight2kg <- function(value = NULL, unit = NULL) {
  if(is.null(value)) {
    stop("No weight value specified.")
  }
  if(!is.null(unit) && !is.na(unit)) {
    if(tolower(unit) %in% c("kg", "lbs", "pound", "pounds", "oz", "ounce", "ounces")) {
      if(tolower(unit) %in% c("lbs", "pound", "pounds")) {
        value <- value / 2.20462
      }
      if(tolower(unit) %in% c("oz", "ounce", "ounces")) {
        value <- value / 35.274
      }
    } else {
      warning(paste0("Unit (", unit,") not recognized, returning original weight."))
    }
  } else {
    warning("Weight unit not specified, returning weight in original unit.")
  }
  return(value)
}
