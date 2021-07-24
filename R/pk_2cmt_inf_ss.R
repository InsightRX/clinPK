#' Concentration predictions for 2-compartmental PK model with infusion dosing at steady state
#'
#' @param t vector of time
#' @param t_inf infusion time
#' @param dose dose
#' @param tau dosing interval
#' @param CL clearance
#' @param V volume of distribution
#' @param Q inter-compartimental clearance
#' @param V2 volume of peripheral compartment
#' @param ruv residual variability, specified as list with optional arguments for proportional, additive, or exponential components, e.g. `list(prop=0.1, add=1, exp=0)`
#' @examples
#' pk_2cmt_inf_ss(
#'   dose = 1000, tau = 12, t_inf = 2,
#'   CL = 5, V = 50, Q = 20, V2 = 200)
#' @export
pk_2cmt_inf_ss <- function(
    t = c(0:24),
    dose = 100,
    t_inf = 1,
    tau = 12,
    CL = 3,
    V = 30,
    Q = 2,
    V2 = 20,
    ruv = NULL
  ) {
  k <- CL / V
  tmp <- c()
  t_dos <- t %% tau

  # reparametrization:
  terms <- (Q/V) + (Q/V2) + (CL/V)
  beta <- 0.5 * (terms - sqrt(terms^2 - 4*(Q/V2)*(CL/V)))
  alpha <- ((Q/V2)*(CL/V))/beta
  A <- (1/V) * (alpha - (Q/V2))/(alpha-beta)
  B <- (1/V) * ((beta - Q/V2)/(beta-alpha))

  dat <- data.frame(t = t, dv = 0)
  dat$dv[t_dos <= t_inf] <-
    (dose/t_inf) * (
      (A/alpha) * ((1-exp(-alpha*t_dos[t_dos <= t_inf])) +
        exp(-alpha*tau) *
          ( (1-exp(-alpha*t_inf)) *
            exp(-alpha*(t_dos[t_dos <= t_inf] - t_inf)) / (1-exp(-alpha*tau)) ) ) +
      (B/beta)  * ((1-exp(-beta * t_dos[t_dos <= t_inf])) +
        exp(-beta*tau) *
          ( (1-exp(-beta*t_inf)) *
              exp(-beta*(t_dos[t_dos <= t_inf] - t_inf)) / (1-exp(-beta*tau)) ) )
    )
  dat$dv[t_dos > t_inf] <-
    (dose/t_inf) * (
      ((A/alpha) * (1-exp(-alpha*t_inf)) * exp(-alpha * (t_dos[t_dos > t_inf] - t_inf)) / (1-exp(-alpha*tau)) ) +
      ((B/beta)  * (1-exp(-beta *t_inf)) * exp(-beta  * (t_dos[t_dos > t_inf] - t_inf)) / (1-exp(-beta*tau)) )
    )

  if(!is.null(ruv)) {
    dat$dv <- add_ruv (dat$dv, ruv)
  }
  return(dat)
}
