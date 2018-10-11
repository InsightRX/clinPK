#' Add residual variability to data
#'
#' @param x data
#' @param ruv list with arguments prop, add, exp
#' @examples
#' y <- pk_1cmt_inf()$y
#' y + add_ruv(y, list(prop = 0.1, add = 0.05))
#' @export
add_ruv <- function (x, ruv = list()) {
  if(!is.null(ruv$prop)) {
    x <- x * (1 + stats::rnorm(length(x), 0, ruv$prop))
  }
  if(!is.null(ruv$add)) {
    x <- x + stats::rnorm(length(x), 0, ruv$add)
  }
  if(!is.null(ruv$exp)) {
    x <- x * exp(stats::rnorm(length(x), 0, ruv$exp))
  }
  return (x)
}
