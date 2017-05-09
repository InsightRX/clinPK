#' Cmin (trough) for 2-compartmental PK model, bolus dosing at steady state
#'
#' @param dose dose
#' @param tau dosing interval
#' @param t_inf infusion time
#' @param CL clearance
#' @param V volume of central compartment
#' @param Q inter-compartimental clearance
#' @param V2 volume of peripheral compartment
#' @param ruv residual error (list)
#' @export
pk_2cmt_inf_cmin_ss <- function(
  dose = 100,
  tau = 12,
  t_inf = 1,
  CL = 3,
  V = 30,
  Q = 2,
  V2 = 20,
  ruv = NULL
) {
  return(pk_2cmt_inf_ss(
    t=tau-1e-10,
    dose = dose, tau=tau, t_inf = t_inf,
    CL=CL, V=V, Q=Q, V2=V2,
    ruv=ruv)$dv)
}
