#' Cmax for 2-compartmental PK model, bolus dosing at steady state
#'
#' @param dose dose
#' @param tau dosing interval
#' @param CL clearance
#' @param V volume of central compartment
#' @param Q inter-compartimental clearance
#' @param V2 volume of peripheral compartment
#' @param ruv residual error (list)
#' @examples
#' pk_2cmt_bolus_cmax_ss(dose = 1000, tau = 12, CL = 5, V = 50, Q = 20, V2 = 200)
#' @export
pk_2cmt_bolus_cmax_ss <- function(
  dose = 100,
  tau = 12,
  CL = 3,
  V = 30,
  Q = 2,
  V2 = 20,
  ruv = NULL
) {
  return(pk_2cmt_bolus_ss(
    t = rep(0, length(dose)),
    dose = dose, tau=tau,
    CL=CL, V=V, Q=Q, V2=V2,
    ruv=ruv)$dv)
}
