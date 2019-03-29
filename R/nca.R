#' Perform an NCA based on a NONMEM-style dataset
#'
#' @param data data.frame with time and dv columns
#' @param dose dose amount
#' @param tau dosing frequency, default is 24.
#' @param method `log_linear` or `linear`
#' @param scale list with scaling for auc and concentration (`conc`)
#' @param dv_min minimum concentrations, lower observations will be set to this value
#' @param extend perform an 'extended' NCA, i.e. for the calculation of the AUCs, back-extend to the expected true Cmax to also include that area.
#' @param has_baseline does the included data include a baseline? If `FALSE`, baseline is set to zero.
#' @examples
#' data <- data.frame(time = c(0, 2, 4, 6, 8, 12, 16),
#'                    dv   = c(0, 10, 14, 11, 9, 5, 1.5))
#' nca(data)
#' @export
nca <- function (
    data = NULL,
    dose = 100,
    tau = 24,
    method = "log_linear",
    scale = list(auc = 1, conc = 1),
    dv_min = 1e-3,
    t_inf = 0,
    extend = TRUE,
    has_baseline = TRUE
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
    baseline <- 0
    data_fit <- data
    if(has_baseline) {
      baseline <- data$dv[1]
      data_fit <- data_fit[-1,]
    }
    last_n <- 3
    if (length(data[,1]) > 4) { last_n = 4 }
    if (length(data[,1]) == 2 ) { last_n = 2 }
    fit <- stats::lm(dv_log ~ time, utils::tail(data_fit, last_n))
    out <- list(pk = list(), descriptive = list())
    out$pk$kel <- -stats::coef(fit)[["time"]]
    out$pk$t_12 <- log(2) / out$pk$kel
    out$pk$v <- dose / (exp(stats::coef(fit)[[1]]) - baseline)
    out$pk$cl <- (out$pk$kel) * out$pk$v

    ## get the auc
    tmax_id <- match(max(data$dv), data$dv)[1]
    out$descriptive$tmax <- out$time[tmax_id]
    pre <- data[1:tmax_id,]
    trap <- data[tmax_id:length(data[,1]),]
    if (length(pre[,1]) > 0) {
      auc_pre <- sum(diff(pre$time) * (mean_step(pre$dv) ) )
    } else {
      auc_pre <- 0
    }
    do_trapezoid <- function(data) {
      sum(diff(data$time) * (diff(data$dv)) / log(data$dv[2:length(data$dv)] / data$dv[1:(length(data$dv)-1)]))
    }
    if (length(pre[,1])>0 & length(trap[,1]) >= 2) {
      if (method == "log_linear") {
        auc_post <- do_trapezoid(trap)
      } else {
        auc_post <- sum(diff(trap$time) * (mean_step(trap$dv)))
      }
      auc_t <- (auc_pre + auc_post)
      c_at_tmax <- data$time[1] 
      c_at_tau  <- utils::tail(data$time,1)
      if(tau > utils::tail(data$time,1)) {
        # AUCtau is extrapolated to tau and back-extrapolated to tmax!
        c_at_tau <- utils::tail(trap$dv,1) * exp(-out$pk$kel * (tau-utils::tail(data$time,1)))
        if(extend) { # back-extrapolate to the true Cmax, to include that area too
            c_at_tmax <- trap$dv[1] * exp(-out$pk$kel * (t_inf - trap$time[1]))
            trap_tau <- rbind(
              trap[,c("time", "dv")],
              data.frame(
                time = c(t_inf, tau),
                dv = c(c_at_tmax, c_at_tau) 
              )
            )
            trap_t <- rbind(
              trap[,c("time", "dv")],
              data.frame(
                time = c(t_inf),
                dv = c(c_at_tmax) 
              )
            )
            trap_tau <- trap_tau[order(trap_tau$time), ]
            trap_t <- trap_t[order(trap_t$time), ]
            auc_tau <- auc_pre + do_trapezoid(trap_tau)
            auc_t   <- auc_pre + do_trapezoid(trap_t) # also recalculate auc_t
        } else {
            auc_tau <- auc_pre + do_trapezoid(trap)
        }
      } else {
        auc_tau <- auc_t
      }
      auc_inf <- auc_tau + c_at_tau / out$pk$kel
      out$descriptive$css_t <- (auc_t / diff(range(data$time))) * scale$conc  # css,t
      out$descriptive$css_tau <- (auc_tau / tau) * scale$conc
      out$descriptive$c_min <- c_at_tau
      if(extend) {
        out$descriptive$c_max_true <- c_at_tmax
      } else {
        out$descriptive$c_max <- c_at_tmax
      }
      out$descriptive$auc_inf <- auc_inf * scale$auc
      out$descriptive$auc_24 <- auc_tau * (24/tau) * scale$auc
      out$descriptive$auc_tau <- auc_tau * scale$auc
      out$descriptive$auc_t <- auc_t * scale$auc
      out$settings <- list(dose = dose, interval = tau)
    }
    return(out)
  }
}
