#' Calculate dose to achieve steady state trough
#' for 1-compartmental PK model with infusion dosing at steady state
#'
#' @param cmin desired trough concentration
#' @param t_inf infusion time
#' @param tau dosing interval
#' @param CL clearance
#' @param V volume of distribution
#' @export
pk_1cmt_inf_dose_from_cmin <- function(cmin = 1, tau = 12, t_inf = 1,
                                       CL = 3, V = 30) {

  # reparametrization:
  k <- CL / V
  dose  <- (cmin * (CL * t_inf)) / ((1-exp(-k*t_inf)) * exp(-k*(tau - t_inf)) / (1-exp(-k*tau)))
  return(dose)
}
