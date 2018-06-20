#' Calculate dose to achieve steady state Cmax
#' for 1-compartmental PK model with infusion dosing at steady state
#'
#' @param cmax desired trough concentration
#' @param t_inf infusion time
#' @param tau dosing interval
#' @param CL clearance
#' @param V volume of distribution
#' @examples
#' pk_1cmt_inf_dose_from_cmax(cmax = 20, tau = 12, t_inf = 2, CL = 5, V = 50)
#' @export
pk_1cmt_inf_dose_from_cmax <- function(cmax = 1, tau = 12, t_inf = 1,
                                       CL = 3, V = 30) {
  # reparametrization:
  k <- CL / V
  dose <- (cmax / ( (1-exp(-(CL/V)*t_inf)) / (1-exp(-(CL/V)*tau)) ) ) * (CL * t_inf)
  return(dose)
}
