#' NCA core function to perform log-linear trapezoid calculations for post-infusion
#'
#' @param data dataset passed from nca() with `time` and `dv` columns
#'
nca_trapezoid <- function(data) {
  data <- data[!duplicated(data$time),]
  enum <- diff(data$time) * (diff(data$dv))
  denom <- log(data$dv[2:length(data$dv)] / data$dv[1:(length(data$dv)-1)])
  if(any(denom == 0)) {
    idx <- denom != 0
    sum(enum[idx] / denom[idx]) + data$dv[!idx]
  } else {
    sum(enum / denom)
  }
}
