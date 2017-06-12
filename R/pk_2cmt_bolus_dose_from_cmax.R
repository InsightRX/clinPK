#' Calculate dose to achieve steady state Cmax
#' for 2-compartmental PK model bolus dosing at steady state
#'
#' @param cmax desired trough concentration
#' @param tau dosing interval
#' @param CL clearance
#' @param V volume of distribution
#' @param Q inter-compartimental clearance
#' @param V2 volume of peripheral compartment
#' @examples
#' dos <- pk_2cmt_bolus_dose_from_cmax(
#'   cmax = 10, tau = 12,
#'   CL = 5, V = 50, Q = 20, V2 = 200)
#' find_nearest_dose(dos, 100)
#' @export
pk_2cmt_bolus_dose_from_cmax <- function(cmax = 1,
                                         tau = 12,
                                         CL = 3, V = 30,
                                         Q = 2, V2 = 20) {
  # reparametrization:
  k <- CL / V
  terms <- (Q/V) + (Q/V2) + (CL/V)
  beta <- 0.5 * (terms - sqrt(terms^2 - 4*(Q/V2)*(CL/V)))
  alpha <- ((Q/V2)*(CL/V))/beta
  A <- (1/V) * (alpha - (Q/V2))/(alpha-beta)
  B <- (1/V) * ((beta - Q/V2)/(beta-alpha))

  ## equation:
  dose <- cmax / (A*exp(-alpha * 0)/(1-exp(-alpha*tau)) + B*exp(-beta * 0)/(1-exp(-beta*tau)))
  return(dose)
}
