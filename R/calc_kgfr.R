#' Calculate kinetic GFR
#'
#' Calculate the kinetic GFR based on a patients first two serum creatinine measurements. Kinetic GFR may be more predictive of future AKI for patients whose serum creatinine is changing quickly. Briefly, an increase in SCr over the course of a day indicates an effective GFR lower than the most recent SCr measurement may indicate if steadystate is assumed, while a decrease in SCr over a short time indicates a higher effective GFR than the most recent SCr would indicate. There are several ways of approximating maximum theoretical creatinine accumulation rate; here the method used by Pianta et al., (PLoS ONE, 2015) has been implemented.
#'
#' @param scr1 baseline scr
#' @param scr2 second scr measurement
#' @param scr_unit scr unit, defaults to mg/dl
#' @param time_delay time between scr1 and scr2 in hours
#' @param weight patient weight in kg
#' @param vd volume of distribution in L, defaults to 0.6 * weight
#' @param egfr eGFR in ml/min at the time of scr1, or leave blank to call calc_egfr
#' @param egfr_method string, only necessary if egfr is not specified.
#' @param sex string (male or female), only necessary if egfr is not specified.
#' @param age age in years, only necessary if egfr is not specified.
#' @param height in m, necessary only for some egfr calculation methods.
#' @param ... further arguments (optional) to be passed to calc_egfr.
#' @return kGFR, in ml/min
#' @examples
#' calc_kgfr(weight = 100, scr1 = 150, scr2 = 200, scr_unit = 'umol/l',
#'          time_delay = 24, egfr = 30)
#' calc_kgfr(weight = 70, scr1 = 350, scr2 = 300, scr_unit = 'umol/l',
#'           time_delay = 24, egfr_method = 'mdrd', age = 70, sex = 'male')
#' @references \href{https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0125669}{Pianta et al., PLoS ONE (2015)}
#' @export
#'
calc_kgfr <- function(
  scr1 = NULL,
  scr2 = NULL,
  scr_unit = 'mg/dl',
  time_delay = NULL,
  weight = NULL,
  vd = NULL,
  egfr = NULL,
  egfr_method = NULL,
  sex = NULL,
  age = NULL,
  height = NULL,
  ...
) {
  #Check time/scr input
  if(is.null(scr1) & is.null(scr2)){
    stop('Must supply two scr measurements')
  }
  if(is.null(time_delay)) {
    stop('Must supply time between scr measurements')
  }
  if(scr_unit == 'mg/dl') {
    scr1 <- scr1 * 88.4
    scr2 <- scr2 * 88.4
    scr_unit <- 'umol/l'
  }
  if(!(tolower(scr_unit) %in% c("umol/l", "mumol/l", "micromol/l"))) {
    stop('scr unit not recognized')
  }

  #Check egfr input, calculate egfr as required
  if (is.null(egfr) & is.null(egfr_method)){
    stop('Must supply either eGFR or enough information to estimate GFR')
  } else if (is.null(egfr)) {
    egfr <- calc_egfr(method = egfr_method,
                      sex = sex, age = age,
                      weight = weight, height = height,
                      scr = scr1, scr_unit = scr_unit, ...)$value
  }

  if (is.null(vd)) vd <- 0.6 * weight

  daily_cr_production <- scr1 * egfr * 1.44
  max_cr_production <- daily_cr_production / vd
  avg_cr <- mean(scr1, scr2)
  multiplier <- 1 + 24 * (scr1 - scr2) / (time_delay * max_cr_production)
  kgfr <- (daily_cr_production / avg_cr) * multiplier

  if (kgfr < 0) kgfr <- 0
  return(kgfr)
}
