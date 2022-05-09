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
  if(inherits(value, "list") && !is.null(value$value) && !is.null(value$unit)) {
    unit_in <- value$unit
    value <- value$value
  }
  allowed <- valid_units("scr")
  if(! all(tolower(unit_in) %in% allowed)) {
    stop(paste0("Input unit needs to be one of ", paste(allowed, collapse = " ")))
  }
  if(tolower(unit_in) %in% c("mg/dl", "mg_dl")) {
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
