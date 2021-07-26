#' Concentration predictions for 2-compartmental PK model, single or multiple bolus doses
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
#' pk_2cmt_bolus(dose = 1000, tau = 24, CL = 5, V = 50, Q = 15, V2 = 200)
#' @export
pk_2cmt_bolus <- function(
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
  unq_dos <- unique(n_dos) + 1

  # reparametrization:
  terms <- (Q/V) + (Q/V2) + (CL/V)
  beta <- 0.5 * (terms - sqrt(terms^2 - 4*(Q/V2)*(CL/V)))
  alpha <- ((Q/V2)*(CL/V))/beta
  A <- (1/V) * (alpha - (Q/V2))/(alpha-beta)
  B <- (1/V) * ((beta - Q/V2)/(beta-alpha))

  for(i in seq(unq_dos)) {
    sel <- n_dos >= i-1
    tmp <- dat[sel,]
    tmp$t <- tmp$t - (i-1)*tau

    ## equation:
    tmp$dv <- dose * (A*exp(-alpha*tmp$t) + B*exp(-beta*tmp$t))

    dat[sel,]$dv <- dat[sel,]$dv + tmp$dv
  }
  if(!is.null(ruv)) {
    dat$dv <- add_ruv (dat$dv, ruv)
  }
  return(dat)
}
