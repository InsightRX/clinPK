#' Convert albumin from / to units
#' 
#' Accepted units are "g_l" or "g_dl". Arguments supplied to `value` and `from`
#' units must be of the same length. "To" unit must be of length 1.
#' 
#' 
#' @param value albumin measurements
#' @param from from unit, e.g. `"g_l"`. 
#' @param to to flow unit, e.g. `"g_dl"`
#' 
#' @examples 
#' 
#' ## single values
#' convert_albumin_unit(0.6, "g_dl", "g_l")
#' 
#' ## vectorized
#' convert_albumin_unit(
#'   c(0.4, 2, 0.3), 
#'   from = c("g_dl", "g_l", "g_dl"), 
#'   to = c("g_l") 
#')
#'   
#' @export
convert_albumin_unit <- function(
  value = NULL,
  from = NULL,
  to
) {
  accept_units <- c("g_l", "g_dl")
  if (!isTRUE(length(from) == length(value)) || !all(from %in% accept_units)) {
    stop("albumin measurement 'from' unit not recognized")
  }
  if (length(to) != 1 || !to %in% accept_units) {
    stop("albumin measurement 'to' unit not recognized")
  }
  if (to == "g_l") {
    value[from == "g_dl"] <- value[from == "g_dl"] * 10
  } else {
    value[from == "g_l"] <- value[from == "g_l"] * 0.1
  }
  value
}
