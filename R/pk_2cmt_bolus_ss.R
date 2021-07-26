#' Concentration predictions for 2-compartmental PK model, bolus dosing at steady state
#'
#' @param t vector of time
#' @param dose dose
#' @param tau dosing interval
#' @param CL clearance
#' @param V volume of central compartment
#' @param Q inter-compartimental clearance
#' @param V2 volume of peripheral compartment
#' @param ruv residual error (list)
#' @examples
#' pk_2cmt_bolus_ss(dose = 1000, tau = 12, CL = 5, V = 50, Q = 20, V2 = 200)
#' @export
pk_2cmt_bolus_ss <- function(
    t = c(0:24),
    dose = 100,
    tau = 12,
    CL = 3,
    V = 30,
    Q = 2,
    V2 = 20,
    ruv = NULL
  ) {
  k <- CL / V
  tmp <- c()
  dat <- data.frame(t = t, dv = 0)
  t_dos <- t %% tau
  n_dos <- floor(t/tau)

  # reparametrization:
  terms <- (Q/V) + (Q/V2) + (CL/V)
  beta <- 0.5 * (terms - sqrt(terms^2 - 4*(Q/V2)*(CL/V)))
  alpha <- ((Q/V2)*(CL/V))/beta
  A <- (1/V) * (alpha - (Q/V2))/(alpha-beta)
  B <- (1/V) * ((beta - Q/V2)/(beta-alpha))

  ## equation:
  dat$dv <- dose * (A*exp(-alpha*t_dos)/(1-exp(-alpha*tau)) + B*exp(-beta*t_dos)/(1-exp(-beta*tau)))

  if(!is.null(ruv)) {
    dat$dv <- add_ruv (dat$dv, ruv)
  }
  return(dat)
}
