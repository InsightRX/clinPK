#' Check if values in vector are empty
#'
#' @param x vector
#' @export
is.nil <- function(x) {
  return(any(c(is.null(x), length(x) == 0, x == "")))
}

#' factors or characters to numeric
#' @param x value
as.num <- function(x) return (as.numeric(as.character(x)))
