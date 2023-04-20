#' Convert age units between days, weeks, years
#'
#' This function converts ages between units of days, weeks, and years. It does
#' not account for leap years.
#'
#' @param value Value to convert
#' @param unit_in Unit of `value`
#' @param unit_out Output unit
#' @return `value` converted to the appropriate unit
#' @export
#' @examples
#' convert_age_unit(7, "days", "weeks")
#' convert_age_unit(365, "days", "years")
#' convert_age_unit(52, "weeks", "years")
#' convert_age_unit(25, "days", "weeks")
convert_age_unit <- function(value,
                             unit_in = c("days", "weeks", "years"),
                             unit_out = c("days", "weeks", "years")) {
  unit_in <- match.arg(unit_in, several.ok = TRUE)
  unit_out <- match.arg(unit_out)
  if (is.null(value)) {
    return(list(value = NULL, unit = unit_out))
  }
  if (length(unit_in) != length(value) && length(unit_in) != 1) {
    stop("unit_in must be either 1 or the same length as values")
  }

  conv_mat <- matrix(
    c(1, 1/7, 1/365, 7, 1, 1/52, 365, 52, 1),
    nrow = 3,
    byrow = TRUE
  )
  rownames(conv_mat) <- c("days", "weeks", "years")
  colnames(conv_mat) <- c("days", "weeks", "years")

  list(
    value = unname(value * conv_mat[unit_in, unit_out]),
    unit = unit_out
  )
}
