#' Calculate dose to achieve steady state Cmax
#' for 2-compartmental PK model with infusion dosing at steady state
#'
#' @param cmax desired trough concentration
#' @param t_inf infusion time
#' @param tau dosing interval
#' @param CL clearance
#' @param V volume of distribution
#' @param Q inter-compartimental clearance
#' @param V2 volume of peripheral compartment
#' @examples
#' dos <- pk_2cmt_inf_dose_from_cmax(
#'   cmax = 25, tau = 12, t_inf = 2,
#'   CL = 5, V = 50, Q = 20, V2 = 200)
#' find_nearest_dose(dos, 100)
#' @export
pk_2cmt_inf_dose_from_cmax <- function(cmax = 1, tau = 12, t_inf = 1,
                                       CL = 3, V = 30,
                                       Q = 2, V2 = 20) {

  # reparametrization:
  k <- CL / V
  terms <- (Q/V) + (Q/V2) + (CL/V)
  beta <- 0.5 * (terms - sqrt(terms^2 - 4*(Q/V2)*(CL/V)))
  alpha <- ((Q/V2)*(CL/V))/beta
  A <- (1/V) * (alpha - (Q/V2))/(alpha-beta)
  B <- (1/V) * ((beta - Q/V2)/(beta-alpha))

  # calculate:
  dose <- (cmax * t_inf) / (
    ((A/alpha) * (1-exp(-alpha * t_inf)) * exp(-alpha * 0) / (1-exp(-alpha*tau)) ) +
      ((B/beta)  * (1-exp(-beta *t_inf)) * exp(-beta  * 0) / (1-exp(-beta*tau)) )
  )
  return(dose)
}
