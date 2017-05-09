#' Convert creatinine to different unit
#'
#' @param value serum creatinine in either mg/dL or mmol/L
#' @param unit_in unit, either `mg/dL` or `mmol/L`
#' @export
convert_creat_unit <- function(
  value = NULL,
  unit_in = "mg/dL") {
  if(!tolower(unit_in) %in% c("mg/dl", "mmol/l")) {
    stop("Input unit needs to be either mg/dL or mmol/L.")
  }
  if(tolower(unit_in) == "mg/dl") {
    out <- list(
      value = value * 88.42,
      unit = "mmol/L"
    )
  } else {
    out <- list(
      value = value / 88.42,
      unit = "mg/dL"
    )
  }
  return(out)
}
