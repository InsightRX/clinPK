#' Convert albumin from / to units
#' 
#' Accepted units are "g_l" or "g_dl". Arguments supplied to `value` and
#' `unit_in` units must be of the same length. "To" unit must be of length 1.
#' #'
#' @param value albumin measurements
#' @param unit_in from unit, e.g. `"g_l"`.
#' @param unit_out to flow unit, e.g. `"g_dl"`
#' 
#' @examples 
#' 
#' ## single values
#' convert_albumin_unit(0.6, "g_dl", "g_l")
#' 
#' ## vectorized
#' convert_albumin_unit(
#'   c(0.4, 2, 0.3), 
#'   unit_in = c("g_dl", "g_l", "g_dl"),
#'   unit_out = c("g_l")
#')
#'   
#' @export
convert_albumin_unit <- function(value,
                                 unit_in = valid_units("serum_albumin"),
                                 unit_out = valid_units("serum_albumin")) {
  unit_in <- tolower(unit_in)
  unit_out <- tolower(unit_out)
  from <- match.arg(unit_in, several.ok = TRUE)
  to <- match.arg(unit_out)
  if (is.null(unit_out)) {
    stop("Please provide output unit")
  }

  if (length(unit_in) != length(value) && length(unit_in) != 1) {
    stop("length of unit_in must be either 1 or the same as values")
  }

  conv <- c(g_dl = 1, `g/dl` = 1, g_l = .1, `g/l` = .1)

  list(
    value = value * unname(conv[unit_in]) / unname(conv[unit_out]),
    unit = unit_out
  )
}
