#' Perform an NCA based on a NONMEM-style dataset
#'
#' @param data data.frame with time and dv columns
#' @param dose dose amount
#' @param tau dosing frequency, default is 24.
#' @param method `linear`, `log_linear` (default), or `log_log`
#' @param scale list with scaling for auc and concentration (`conc`)
#' @param dv_min minimum concentrations, lower observations will be set to this value
#' @param t_inf infusion time, defaults to 0
#' @param fit_samples vector of sample indexes used in fit to calculate elimination
#' rate, e.g. `c(3,4,5)`. If not specified (default), it will evaluate which of the last n
#' samples shows the largest adjusted R^2 when log-transformed data is fitted using linear
#' regression, and use those samples in the estimation of the elimination rate.
#' @param weights vector of weights to be used in linear regression (same size as specified concentration data), or function with concentration as argument.
#' @param extend perform an 'extended' NCA, i.e. for the calculation of the AUCs, back-extend to the expected true Cmax to also include that area.
#' @param has_baseline does the included data include a baseline? If `FALSE`, baseline is set to zero.
#' @param route administration route, `iv` (intravenous, default), `oral`, `sc` (sub-cutaneous), or `im` (intra-muscular).
#' @return Returns a list of three lists:
#'  \describe{
#'   \item{\code{pk}}{Lists pk parameters.
#'   \itemize{
#'   \item{\code{kel}: elimination constant}
#'   \item{\code{t_12}: half-life}
#'   \item{\code{v}: distribution volume}
#'   \item{\code{cl}: clearance}
#'   }
#'   }
#'   \item{\code{descriptive}}{Lists exposure parameters.
#'   \itemize{
#'   \item{\code{cav_t}: the average concentration between the first observation and the last observation without extrapolating to tau}
#'   \item{\code{cav_tau}: the average concentration from 0 to tau}
#'   \item{\code{cmin}: the extrapolated concentration at \code{time = tau}}
#'   \item{\code{c_max_true}: only available if \code{extend = TRUE}, the extrapolated peak concentration}
#'   \item{\code{c_max}: only available if \code{extend = FALSE}, the observed maximum concentration}
#'   \item{\code{auc_inf}: the extrapolated AUC as time goes to infinity}
#'   \item{\code{auc_24}: the extrapolated AUC after 24 hours, provided no further doses are administered}
#'   \item{\code{auc_tau}: the extrapolated AUC at the end of the dosing interval}
#'   \item{\code{auc_t}: the AUC at the time of the last observation}
#'   }
#'   }
#'   \item{\code{settings}}{Lists dosing information.
#'   \itemize{
#'   \item{\code{dose}: dose quantity}
#'   \item{\code{tau}: dosing interval}
#'   }
#'   }
#'   }
#' @examples
#' data <- data.frame(time = c(0, 2, 4, 6, 8, 12, 16),
#'                    dv   = c(0, 10, 14, 11, 9, 5, 1.5))
#' nca(data, t_inf = 2)
#' @export
nca <- function (
    data = NULL,
    dose = 100,
    tau = 24,
    method = c("log_linear", "log_log", "linear"),
    scale = list(auc = 1, conc = 1),
    dv_min = 1e-3,
    t_inf = NULL,
    fit_samples = NULL,
    weights = NULL,
    extend = TRUE,
    has_baseline = TRUE,
    route = c("iv", "oral", "im", "sc")
  ) {
  if(is.null(data)) {
    stop("No data supplied to NCA function")
  } else {
    route <- match.arg(route)
    method <- match.arg(method)
    if(method == "log_log") {
      if(route != "iv") stop("Cannot use log-log method using non-intravenous data.")
      if(!extend) {
        warning("With log-log method, the data has to be back-extrapolated to end-of-infusion for calculations to be accurate.")
      }
      extend <- TRUE
    }
    if(is.null(data$dv) || is.null(data$time)) {
      stop("No time ('time') or dependent variable ('dv') data in supplied dataset")
    }
    if(sum(is.na(data$dv)) > 0) {
      message(paste0("Removing ", sum(is.na(data$dv)), " datapoint(s) with missing concentration value."))
      data <- data[!is.na(data$dv),]
    }
    if (!is.null(dv_min)) { # protect against log <= 0, but it's OK at first timepoint (t=0)
      if(any(data$dv < dv_min & data$t > 0)) {
        data[data$dv < dv_min & data$t > 0, ]$dv <- dv_min
      }
    }
    if(is.null(t_inf)) {
      stop("No infusion length provided. (Use t_inf = 0 for bolus.)")
    }
    data$dv_log <- log(data$dv)
    baseline <- 0
    if(has_baseline) {
      baseline <- data$dv[1]
    }
    data_fit <- data
    if(inherits(weights, "function")) { # transform f(y) to vector of weights
      weights <- do.call("weights", args = list(data_fit$dv))
    }
    
    if(!is.null(fit_samples)) {
      data_fit <- data_fit[fit_samples,]
      last_n <- nrow(data_fit)
    } else {
      if(has_baseline) {
        data_fit <- data_fit[-1,]
        weights <- weights[-1]
      }
      last_n <- ifelse(length(data[,1]) == 2, 2, 3) # Default is 3, but allow 2 if only 2 samples
      if (length(data[,1]) > 3) { # if more than 3, evaluate which last n samples give the largest adjusted R^2
          test_n_samples <- 4:length(data[,1])
          r_adj <- c()
          for(ns in test_n_samples) {
            r_adj <- c(r_adj, summary(stats::lm(dv_log ~ time, utils::tail(data_fit, ns), weight = utils::tail(weights, ns)))$adj.r.squared)
          }
          last_n <- test_n_samples[which.max(r_adj)]
      }
    }
    fit <- stats::lm(dv_log ~ time, utils::tail(data_fit, last_n), weight = utils::tail(weights, last_n))
    out <- list(pk = list(), descriptive = list())
    out$pk$kel <- -stats::coef(fit)[["time"]]
    out$pk$t_12 <- log(2) / out$pk$kel
    
    ## get the auc
    tmax_id <- match(max(data$dv), data$dv)[1]
    out$descriptive$tmax <- data$time[tmax_id]
    pre <- data[c(1, tmax_id),]
    trap <- data[tmax_id:length(data[,1]),]
    
    if(route == "iv") { ## only calculate / report CL and V for iv.
      if(nrow(pre > 0)) { ## if infusion
        tmax_id <- which.max(pre$dv) # with dense sampling / simulated data it could be that first sample after EOI is not highest.
        c_at_tmax <- pre$dv[tmax_id] * exp(-out$pk$kel * (t_inf - pre$time[tmax_id])) 
        out$pk$v <- ((dose / ( (c_at_tmax - baseline) / (1-exp(-out$pk$kel * t_inf)) )) ) / (out$pk$kel * t_inf)
      } else {
        out$pk$v <- dose / (exp(stats::coef(fit)[[1]]) - baseline) # this is only for bolus
      }
      out$pk$cl <- out$pk$kel * out$pk$v
    }

    if (length(pre[,1]) > 0) {
      if(extend) { # back-extending: then only calculate until EOI, the AUC between EOI and first sample after EOI will be added later
        t_end <- t_inf   
      } else {
        t_end <- diff(pre$time)
      }
      if(method == "log_log") {
        # AUC during infusion is total AUC of dose (A/CL) minus the AUC still to be eliminated (Amount from dose at EOI/CL)
        auc_pre <- dose/out$pk$cl - (c_at_tmax * out$pk$v) / out$pk$cl
      } else {
        auc_pre <- sum(t_end * (mean_step(pre$dv) ) ) # linear or log_lin methods
      }
    } else {
      auc_pre <- 0
    }
    nca_method <- ifelse(method == "linear", nca_linear, nca_trapezoid)
    if (length(pre[,1]) > 0 & length(trap[,1]) >= 2) {
      auc_post <- nca_method(trap)
      auc_t <- (auc_pre + auc_post)
      c_at_tau  <- utils::tail(data$time,1)
      if(tau > utils::tail(data$time,1) || extend) {
        # AUCtau is extrapolated to tau and back-extrapolated to tmax!
        c_at_tau <- utils::tail(trap$dv,1) * exp(-out$pk$kel * (tau-utils::tail(data$time,1)))
        if(extend) { # back-extrapolate to the true Cmax, to include that area too
            if(trap$time[1] > t_inf) {
              c_at_tmax <- trap$dv[1] * exp(-out$pk$kel * (t_inf - trap$time[1]))
            } else {
              c_at_tmax <- trap$dv[1]
            }
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
            auc_tau <- auc_pre + nca_method(trap_tau)
            auc_t   <- auc_pre + nca_method(trap_t) # also recalculate auc_t
        } else {
          trap_tau <- rbind(
            trap[,c("time", "dv")],
            data.frame(
              time = c(tau),
              dv = c(c_at_tau)
            )
          )
          auc_tau <- auc_pre + nca_method(trap_tau)
        }
      } else {
        auc_tau <- auc_t
      }
      auc_inf <- auc_tau + c_at_tau / out$pk$kel
      out$descriptive$cav_t <- (auc_t / diff(range(data$time))) * scale$conc  # cav,t
      out$descriptive$cav_tau <- (auc_tau / tau) * scale$conc
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
      out$descriptive$auc_pre <- auc_pre * scale$auc
      out$settings <- list(dose = dose, interval = tau,
                           last_n = last_n, weights = weights)
    }
    class(out) <- c("nca_output", "list")
    return(out)
  }
}
