#' Convert creatinine to different unit
#'
#' @param value serum creatinine in either mg/dL or micromol/L
#' @param unit_in unit, either `mg/dL` or `micromol/L`
#' @examples
#' convert_creat_unit(1)
#' convert_creat_unit(88.42, unit_in = "micromol/l")
#' @export
convert_creat_unit <- function(
  value = NULL,
  unit_in = "mg/dL") {
  if(class(value) == "list" && !is.null(value$value) && !is.null(value$unit)) {
    unit_in <- value$unit
    value <- value$value
  }
  if(!tolower(unit_in) %in% c("mg/dl", "micromol/l", "mumol/l")) {
    stop("Input unit needs to be either mg/dL or micromol/L.")
  }
  if(tolower(unit_in) == "mg/dl") {
    out <- list(
      value = value * 88.42,
      unit = "micromol/L"
    )
  } else {
    out <- list(
      value = value / 88.42,
      unit = "mg/dL"
    )
  }
  return(out)
}
