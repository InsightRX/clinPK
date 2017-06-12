#' Concentration predictions for 1-compartmental PK model with bolus dosing at steady state
#'
#' @param t vector of time
#' @param dose dose
#' @param tau dosing interval
#' @param CL clearance
#' @param V volume of distribution
#' @param ruv residual variability, specified as list with optional arguments for proportional, additive, or exponential components, e.g. `list(prop=0.1, add=1, exp=0)`
#' @examples
#' pk_1cmt_bolus_ss(dose = 500, tau = 12, CL = 5, V = 50)
#' pk_1cmt_bolus_ss(
#'   dose = 500, tau = 12, CL = 5, V = 50,
#'   ruv = list(prop = 0.1, add = 0.1))
#' @export
pk_1cmt_bolus_ss <- function(
  t = c(0:24),
  dose = 100,
  tau = 12,
  CL = 3,
  V = 30,
  ruv = NULL
) {
  k <- CL / V
  tmp <- c()
  t_dos <- t %% tau
  dat <- data.frame(cbind(t = t, dv = 0))
  dat$dv <- (dose/V) * (exp(-k * t_dos)/(1-exp(-k*tau)))
  if(!is.null(ruv)) {
    dat$dv <- add_ruv (dat$dv, ruv)
  }
  return(dat)
}
