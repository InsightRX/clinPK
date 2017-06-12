#' Concentration predictions for 2-compartmental PK model with infusion dosing at steady state
#'
#' @param t vector of time
#' @param t_inf infusion time
#' @param dose dose
#' @param tau dosing interval
#' @param CL clearance
#' @param V volume of distribution
#' @param ruv residual variability, specified as list with optional arguments for proportional, additive, or exponential components, e.g. `list(prop=0.1, add=1, exp=0)`
#' @examples
#' pk_1cmt_inf_ss(dose = 500, tau = 12, t_inf = 2, CL = 5, V = 50)
#' pk_1cmt_inf_ss(
#'   dose = 500, tau = 12, t_inf = 2, CL = 5, V = 50,
#'   ruv = list(prop = 0.1, add = 0.1))
#' @export
pk_1cmt_inf_ss <- function(
    t = c(0:24),
    dose = 100,
    t_inf = 1,
    tau = 12,
    CL = 3,
    V = 30,
    ruv = NULL
  ) {
  k <- CL / V
  tmp <- c()
  t_dos <- t %% tau
  dat <- data.frame(cbind(t = t, dv = 0))
  dat$dv[t_dos <= t_inf] <- (dose / (CL * t_inf)) * ((1-exp(-k * t_dos[t_dos <= t_inf]) + (exp(-k*tau) * (1-exp(-k*t_inf)) * exp(-k*(t_dos[t_dos <= t_inf] - t_inf)) / (1-exp(-k*tau)))))
  dat$dv[t_dos > t_inf]  <- (dose / (CL * t_inf)) * (1-exp(-k*t_inf)) * exp(-k*(t_dos[t_dos > t_inf] - t_inf)) / (1-exp(-k*tau))
  if(!is.null(ruv)) {
    dat$dv <- add_ruv (dat$dv, ruv)
  }
  return(dat)
}
