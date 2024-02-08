#' Convert bilirubin from / to units
#'
#' Accepted units are "mg_dl" and "micromol_l". Arguments supplied to `value` and
#' `unit_in` units must be of the same length. "To" unit must be of length 1.
#' #'
#' @param value bilirubin measurements
#' @param unit_in from unit, e.g. `"g_l"`.
#' @param unit_out to flow unit, e.g. `"g_dl"`
#'
#' @examples
#'
#' ## single values
#' convert_bilirubin_unit(1, "mg_dl", "micromol_l")
#'
#' ## vectorized
#' convert_bilirubin_unit(
#'   c(1, 1.1, 1.2),
#'   unit_in = "mg_dl",
#'   unit_out = "micromol_l"
#')
#'
#' @export
convert_bilirubin_unit <- function(value,
                                 unit_in = valid_units("bilirubin"),
                                 unit_out = valid_units("bilirubin")) {
  unit_in <- tolower(unit_in)
  unit_out <- tolower(unit_out)
  from <- match.arg(unit_in, several.ok = TRUE)
  to <- match.arg(unit_out)
  if (is.null(unit_out)) {
    stop("Please provide output unit")
  }

  convert_conc_unit(value, unit_in, unit_out, 584.673)
}
