#' Print function for output from nca()
#'
#' @param x output object (list) from nca()
#' @param ... variables past on to print function
#' @export
#' @keywords internal
print.nca_output <- function(x, ...) {
  res <- rbind(data.frame(value = t(as.data.frame(x$pk))),
               data.frame(value = t(as.data.frame(x$descriptive))))
  res$value <- format(round(res$value, 4), scientific = FALSE)
  print(res)
}
