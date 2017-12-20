#' Calculate dose based on a given AUC24, Cmax, and Cmin, assuming 1-compartment model
#'
#' @param target list of `auc`, `cmax`, and `cmin`
#' @param parameters list of `CL` and `V`
#' @param interval dosing interval
#' @param t_inf infusion time
#' @param round_interval round interval to nearest nominal interval?
#' @export
calc_dose_auc_cmax_cmin <- function(
  target = list(),
  parameters = list(),
  interval = 24,
  t_inf = 1,
  round_interval = TRUE) {
  calc_interval <- (log(target$cmin / target$cmax) / -parameters$kel) + t_inf
  calc_daily_dose <- target$auc * parameters$CL * (calc_interval/interval)
  calc_dose <- calc_daily_dose * (interval/24)
  if(round_interval) {
    new_interval <- clinPK::find_nearest_interval(calc_interval, c(6,8,12,24,36))
    calc_dose <- calc_dose * (new_interval / calc_interval)
    calc_interval <- new_interval
  }
  return(list(
    dose = calc_dose,
    interval = calc_interval
  ))
}
