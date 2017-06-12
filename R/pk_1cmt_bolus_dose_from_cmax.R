#' Calculate dose to achieve steady state Cmax
#' for 1-compartmental PK model bolus dosing at steady state
#'
#' @param cmax desired trough concentration
#' @param tau dosing interval
#' @param CL clearance
#' @param V volume of distribution
#' @examples
#' dos <- pk_1cmt_bolus_dose_from_cmax(
#'   cmax = 10, tau = 12, CL = 5, V = 50)
#' find_nearest_dose(dos, 100)
#' @export
pk_1cmt_bolus_dose_from_cmax <- function(cmax = 1,
                                         tau = 12,
                                         CL = 3, V = 30) {

  # reparametrization:
  k <- CL / V
  tmp <- c()
  dat <- data.frame(cbind(t = t, dv = 0))

  ## equation:
  dose <- (cmax * V) * (1-exp(-(CL/V)*tau))
  return(dose)
}
