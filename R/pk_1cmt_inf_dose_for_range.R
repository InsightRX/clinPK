#' Calculate dose based on a given AUC24, Cmax, and Cmin, assuming 1-compartment model
#'
#' @param target numeric value of target
#' @param type target type, one of `auc`, `auc24`, `ctrough`, `cmin`
#' @param conc_range concentration range to stay within, vector of length 2
#' @param parameters list of `CL` and `V`, or `KEL` and `CL`
#' @param interval dosing interval
#' @param t_inf infusion time
#' @param optimize_interval find optimal interval (to stay within `conc_range`?
#' @param round_interval round interval to nearest nominal interval?
#' @export
pk_1cmt_inf_dose_for_range <- function(
  target = 500,
  type = "auc",
  conc_range = c(10, 40),
  parameters = list(),
  interval = 24,
  t_inf = 1,
  optimize_interval = TRUE,
  round_interval = TRUE) {
    types <- c("auc", "auc24", "ctrough", "cmin")
    if(!(type %in% types)) {
      stop(paste0("Target `type` needs to be one of ", types))
    }
    if(!is.null(parameters$kel)) parameters$KEL <- parameters$kel
    if(is.null(parameters$KEL) && !is.null(parameters$CL) && !is.null(parameters$V)) {
      parameters$KEL <- parameters$CL / parameters$V
    } else {
      stop("Need parameters KEL and CL, or CL and V to calculate dose!")
    }
    if(optimize_interval) {
      calc_interval <- (log(min(conc_range) / max(conc_range)) / -parameters$KEL) + t_inf
    } else {
      calc_interval <- interval
    }
    if(type %in% c("auc", "auc24")) {
      calc_daily_dose <- target * parameters$CL * (calc_interval/interval)
      calc_dose <- calc_daily_dose * (interval/24)
    }
    if(type %in% c("ctrough", "cmin")) {
      dummy <- 1000
      cmin_expected <- pk_1cmt_inf_cmin_ss(
        dose = dummy, # dummy value
        tau = calc_interval, CL = parameters$CL, V = parameters$V, t_inf = t_inf, ruv = NULL)
      calc_dose <- dummy * (target / cmin_expected)
    }
    if(optimize_interval && round_interval) {
      new_interval <- clinPK::find_nearest_interval(calc_interval, c(6,8,12,24,36))
      calc_dose <- calc_dose * (new_interval / calc_interval)
      calc_interval <- new_interval
    }
    return(list(
      dose = calc_dose,
      interval = calc_interval
    ))
}
