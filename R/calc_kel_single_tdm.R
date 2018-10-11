#' Calculate elimination rate when given a single TDM sample
#'
#' Using iterative k_el calculation, and based on given Volume
#'
#' @param dose dose amount
#' @param V volume of distribution
#' @param t time or time after dose
#' @param dv observed value
#' @param tau dosing interval
#' @param t_inf infusion time
#' @param kel_init estimate of elimination rate
#' @param n_iter number of iterations to improve estimate of elimination rate
#' @param learn_rate default is 0.2
#' @examples
#' calc_kel_single_tdm(dose = 1000, t = 18)
#' @export
calc_kel_single_tdm <- function (
  dose = 1000,
  V = 50,
  t = 10,
  dv = 10,
  tau = 12,
  t_inf = 1,
  kel_init = 0.1,
  n_iter = 25,
  learn_rate = 0.2
) {
  t_next_dose <- tau - (t %% tau)
  kel <- kel_init
  for(i in 1:n_iter) {
    cpeak <- clinPK::pk_1cmt_inf_cmax_ss(
      dose = dose, CL = kel * V, V = V, tau = tau, t_inf = t_inf
    )
    cpred <- clinPK::pk_1cmt_inf_ss(
      t = t,
      dose = dose, CL = kel * V, V = V, tau = tau, t_inf = t_inf)
    kel <- kel * (cpred$dv/dv)^(learn_rate)
  }
  return(kel)
}
