#' Calculate dose to achieve steady state trough
#' for 1-compartmental PK model bolus dosing at steady state
#'
#' @param cmin desired trough concentration
#' @param tau dosing interval
#' @param CL clearance
#' @param V volume of distribution
#' @examples
#' dos <- pk_1cmt_bolus_dose_from_cmin(
#'   cmin = 5, tau = 12, CL = 5, V = 50)
#' find_nearest_dose(dos, 100)
#' @export
pk_1cmt_bolus_dose_from_cmin <- function(cmin = 1,
                                         tau = 12,
                                         CL = 3, V = 30) {

  # reparametrization:
  k <- CL / V
  tmp <- c()
  dat <- data.frame(cbind(t = t, dv = 0))

  ## equation:
  dose <- (cmin*V) / (exp(-k * tau) / (1-exp(-k*tau)))
  return(dose)
}
