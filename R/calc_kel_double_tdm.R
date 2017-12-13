#' Calculate elimination rate when given two TDM samples
#'
#' @param dose dose amount
#' @param t time or time after dose, vector of size 2
#' @param dv observed value, vector of size 2
#' @param tau dosing interval
#' @param t_inf infusion time
#' @param steady_state samples taken at steady state?
#' @param trapezoidal use trapezoidal rule to calculate AUC? Otherwise use dose/CL.
#' @param return_parameters return all parameters instead of only kel?
#' @examples
#' calc_kel_double_tdm(dose = 1000, t = c(3, 18), dv = c(30, 10))
#' @export
calc_kel_double_tdm <- function (
  dose = 1000,
  t = c(2, 11.5),
  dv = c(30, 10),
  tau = 12,
  t_inf = 1,
  steady_state = TRUE,
  trapezoidal = FALSE,
  return_parameters = FALSE
) {
  if(length(t) != 2 || length(dv) != 2) {
    stop("`t` and `dv` need to be a vector of length 2!")
  }
  kel <- log(max(dv) / min(dv)) / abs(diff(t))
  t12 <- log(2) / kel
  cmax <- max(dv) / exp(-kel * (t[1] - t_inf))
  cmin <- cmax * exp(-kel * (tau - t_inf))
  V <- (dose/t_inf) * (1-exp(-kel * t_inf)) / (kel*cmax)
  if(steady_state) {
    V <- V * 1/(1-exp(-kel * tau))
  }
  CL <- V * kel
  if(trapezoidal) {
    AUC <- ((cmax - cmin) / (log(cmax) - log(cmin))) * (tau - t_inf)
    if(steady_state) {
      AUC <- AUC + (cmax - cmin) * t_inf/2 + cmin * t_inf
    } else {
      AUC <- AUC + (cmax * t_inf/2)
    }
  } else {
    AUC <- dose / CL
  }
  if(return_parameters) {
    return(list(
      kel = kel,
      t12 = t12,
      V = V,
      CL = CL,
      cmax = cmax,
      cmin = cmin,
      AUCss = AUC,
      AUCss24 = AUC * (24/tau)
    ))
  }
  return(kel)
}
