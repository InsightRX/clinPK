#' Check if values in vector are empty
#'
#' @param x vector
is.nil <- function(x = NULL) {
  return(is.null(x) || any(c(length(x) == 0, is.na(x), is.nan(x), x == "")))
}

#' factors or characters to numeric
#' @param x value
as.num <- function(x) return (as.numeric(as.character(x)))
