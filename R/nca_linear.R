#' NCA core function to perform linear trapezoid calculations for post-infusion
#'
#' @inheritParams nca_trapezoid
#'
nca_linear <- function(data) {
  sum(diff(data$time) * (mean_step(data$dv)))
}

#' Calculate mean between two timepoints for a vector
#' 
#' @returns a vector of length(x)-1 with the mean timepoints
mean_step <- function(x) { 
  (x[1:(length(x)-1)] + x[2:length(x)]) / 2 
}

