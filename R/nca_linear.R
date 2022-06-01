#' NCA core function to perform linear trapezoid calculations for post-infusion
#'
#' @inheritParams nca_trapezoid
#' @keywords internal
nca_linear <- function(data) {
  sum(diff(data$time) * (mean_step(data$dv)))
}

#' Calculate mean between two values in a vector
#' Used in NCA for calculation of mean between two or more timepoints.
#' 
#' @param x vector of numeric values
#' @keywords internal
#' @return a vector of length(x)-1 with the mean timepoints
mean_step <- function(x) { 
  x[-length(x)] + diff(x) / 2 
}


