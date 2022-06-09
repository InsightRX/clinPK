#' NCA core function to perform log-linear trapezoid calculations for post-infusion
#'
#' @param data dataset passed from nca() with `time` and `dv` columns
#' @keywords internal
nca_trapezoid <- function(data) {
  data <- data[!duplicated(data$time),]
  enum <- diff(data$time) * (diff(data$dv))
  denom <- log(data$dv[2:length(data$dv)] / data$dv[1:(length(data$dv)-1)])
  if(any(denom == 0)) {
    idx <- denom != 0
    data$dt <- c(diff(data$time), 0)
    sum(enum[idx] / denom[idx]) + sum(data$dv[!idx] * data$dt[!idx])
  } else {
    sum(enum / denom)
  }
}
