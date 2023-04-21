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
  if (length(unit_in) != length(value) && length(unit_in) != 1) {
    stop("length of unit_in must be either 1 or the same as values")
  }
  unit_in <- match.arg(unit_in, several.ok = TRUE)
  unit_out <- match.arg(unit_out)

  conv <- c(
    `mg/dl`      = 1,
    mg_dl        = 1,
    `micromol/l` = 1 / 88.42,
    micromol_l   = 1 / 88.42,
    micromol     = 1 / 88.42,
    mmol         = 1 / 88.42,
    `mumol/l`    = 1 / 88.42,
    `umol/l`     = 1 / 88.42
  )

  list(
    value = value * unname(conv[unit_in]) / unname(conv[unit_out]),
    unit = unit_out
  )
}
