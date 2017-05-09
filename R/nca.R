#' Perform an NCA based on a NONMEM-style dataset
#'
#' @param data data.frame with time and dv columns
#' @param dose dose amount
#' @param tau dosing frequency
#' @param method `log_linear` or `linear`
#' @param scale list with scaling for auc and concentration (`conc`)
#' @param dv_min minimum concentrations, lower observations will be set to this value
#' @export
nca <- function (
    data = NULL,
    dose = 100,
    tau = 6,
    method = "log_linear",
    scale = list(auc = 1, conc = 1),
    dv_min = 1e-3
  ) {
  if(is.null(data)) {
    stop("No data supplied to NCA function")
  } else {
    if(is.null(data$dv) || is.null(data$time)) {
      stop("No time ('time') or dependent variable ('dv') data in supplied dataset")
    }
    mean_step <- function(x) { (x[1:(length(x)-1)] + x[2:length(x)]) / 2 }
    if(sum(is.na(data$dv)) > 0) {
      message(paste0("Removing ", sum(is.na(data$dv)), " datapoint(s) with missing concentration value."))
      data <- data[!is.na(data$dv),]
    }
    if (!is.null(dv_min)) { # protect against log <= 0
      if(sum(data$dv < dv_min) > 0) {
        data[data$dv < dv_min, ]$dv <- dv_min
      }
    }
    data$dv_log <- log(data$dv)
    last_n <- 3
    if (length(data[,1]) > 4) { last_n = 4 }
    fit <- stats::lm(dv_log ~ time, utils::tail(data, last_n))
    out <- list()
    out$kel <- -stats::coef(fit)[["time"]]
    out$t_12 <- log(2) / out$kel
    out$v <- exp(stats::coef(fit)[[1]] - data$dv_log[1]) / dose
    out$cl <- (out$kel) * out$v

    ## get the auc
    tmax_id <- match(max(data$dv), data$dv)[1]
    out$tmax <- out$time[tmax_id]
    pre <- data[1:tmax_id,]
    trap <- data[tmax_id:length(data[,1]),]
    if (length(pre[,1]) > 0) {
      auc_pre <- sum(diff(pre$time) * (mean_step(pre$dv) ) )
    } else {
      auc_pre <- 0
    }
    if (length(pre[,1])>0 & length(trap[,1]) > 2) {
      if (method == "log_linear") {
        auc_post <- sum(diff(trap$time) * (diff(trap$dv)) / log(trap$dv[2:length(trap$dv)] / trap$dv[1:(length(trap$dv)-1)]))
      } else {
        auc_post <- sum(diff(trap$time) * (mean_step(trap$dv)))
      }
      auc_t <- (auc_pre + auc_post)
      auc_inf <- auc_t + (utils::tail(trap$dv,1)/out$kel)
      if(tau > utils::tail(data$time,1)) {
        c_at_tau <- utils::tail(trap$dv,1) * exp(-out$kel * (tau-utils::tail(data$time,1)))
        auc_tau <- auc_inf - (c_at_tau/out$kel)
      } else {
        auc_tau <- auc_t
      }
      out$auc_t <- auc_t * scale$auc
      out$auc_inf <- auc_inf * scale$auc
      out$auc_tau <- auc_tau * scale$auc
      out$css <- (auc_t / diff(range(data$time))) * scale$conc  # css,t
      out$css_tau <- (auc_tau / tau) * scale$conc
    }
    return(out)
  }
}
