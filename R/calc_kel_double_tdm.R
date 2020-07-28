#' Calculate elimination rate when given two TDM samples
#'
#' @param dose dose amount
#' @param t time or time after dose, vector of size 2
#' @param dv observed value, vector of size 2
#' @param tau dosing interval
#' @param t_inf infusion time
#' @param V if specified, use that (empiric) value and don't estimate from data. Default `NULL`.
#' @param steady_state samples taken at steady state? Only influences AUCtau.
#' @param return_parameters return all parameters instead of only kel?
#' @examples
#' calc_kel_double_tdm(dose = 1000, t = c(3, 18), dv = c(30, 10))
#' 
#' @export
calc_kel_double_tdm <- function (
  dose = 1000,
  t = c(2, 11.5),
  dv = c(30, 10),
  tau = 12,
  t_inf = 1,
  V = NULL,
  steady_state = TRUE,
  return_parameters = FALSE
) {
  if(length(t) != 2 || length(dv) != 2) {
    stop("`t` and `dv` need to be a vector of length 2!")
  }
  kel <- log(max(dv) / min(dv)) / abs(diff(t))
  t12 <- log(2) / kel
  cmax <- max(dv) / exp(-kel * (t[1] - t_inf))
  cmin <- cmax * exp(-kel * (tau - t_inf))
  if(is.null(V)) {
    V <- (dose/t_inf) * (1-exp(-kel * t_inf)) / (kel*cmax)
    if(steady_state) {
      V <- V * 1/(1-exp(-kel * tau))
    }
  }
  CL <- V * kel
  AUCtau <- ((cmax - cmin) / (log(cmax) - log(cmin))) * (tau - t_inf)
  if(steady_state) {
    AUCtau <- AUCtau + (cmax - cmin) * t_inf/2 + cmin * t_inf
  } else {
    AUCtau <- AUCtau + (cmax * t_inf/2)
  }
  AUCss <- dose / CL
  if(return_parameters) {
    return(list(
      kel = kel,
      t12 = t12,
      V = V,
      CL = CL,
      cmax = cmax,
      cmin = cmin,
      AUCtau = AUCtau,
      AUCss = AUCss,
      AUCss24 = AUCss * (24/tau),
      input = list(
        dose = dose,
        t = t,
        dv = dv,
        tau = tau, 
        t_inf = t_inf,
        V = V,
        steady_state = steady_state
      )
    ))
  }
  return(kel)
}
