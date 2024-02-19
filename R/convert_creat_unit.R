#' Convert creatinine to different unit
#'
#' @param value serum creatinine in either mg/dL or micromol/L
#' @param unit_in,unit_out unit, either `mg/dL` or `micromol/L`
#' @examples
#' convert_creat_unit(1, "mg/dL", "micromol/l")
#' convert_creat_unit(88.42, "micromol/l", "mg/dL")
#' @export
convert_creat_unit <- function(value,
                               unit_in = valid_units("scr"),
                               unit_out = valid_units("scr")) {
  unit_in <- tolower(unit_in)
  unit_out <- tolower(unit_out)
  unit_in <- match.arg(unit_in, several.ok = TRUE)
  unit_out <- match.arg(unit_out)

  convert_conc_unit(value, unit_in, unit_out, 113.12)
}
