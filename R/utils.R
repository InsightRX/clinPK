#' Check if values in vector are empty
#'
#' @param x vector
#' @keywords internal
is.nil <- function(x = NULL) {
  return(is.null(x) || any(c(length(x) == 0, is.na(x), is.nan(x), x == "")))
}

#' factors or characters to numeric
#' @param x value
#' @keywords internal
as.num <- function(x) return (as.numeric(as.character(x)))

#' Remove less-than/greater-than symbols and convert to numeric
#'
#' The following characters will be removed from strings: <, >, =, space. If
#' string contains other characters, the original string will be returned.
#'
#' @keywords internal
#' @param x Vector of numbers possibly containing extraneous strings.
#' @return If non-numeric characters were successfully removed, returns a
#'   numeric vector. If some elements of `x` contained other characters, their
#'   original value will be returned and the result will be a character vector.
remove_lt_gt <- function(x) {
  if (!inherits(x, "character")) {
    return(x)
  }
  num_na <- sum(is.na(x))
  idx <- grep("[^<>=\\.-[:space:][:digit:]]+", x, invert = TRUE)
  x[idx] <- gsub("[<>=[:space:]]", "", x[idx])

  if (suppressWarnings(sum(is.na(as.numeric(x)))) > num_na) {
    return(x)
  } else {
    return(as.numeric(x))
  }
}

#' Greater-than-or-equal-to with a little room for floating point precision
#' issues
#'
#' @keywords internal
#' @param x Numeric vector
#' @param y Numeric vector
`%>=%` <- function(x, y) {
  if (length(x) == 0 | length(y) == 0) {
    return(logical(0))
  }
  x > y | mapply(function(x, y) isTRUE(all.equal(x, y)), x, y)
}

#' Less-than-or-equal-to with a little room for floating point precision
#' issues
#'
#' @keywords internal
#' @param x Numeric vector
#' @param y Numeric vector
#' @export
`%<=%` <- function(x, y) {
  if (length(x) == 0 | length(y) == 0) {
    return(logical(0))
  }
  x < y | mapply(function(x, y) isTRUE(all.equal(x, y)), x, y)
}
