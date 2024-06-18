#' Estimate serum creatinine
#'
#' Calculate an estimated serum creatinine. Function takes vectorized input as well.
#'
#' Uses equations described in Ceriotti et al. Clin Chem. 2008, and Junge W et al.
#' Clin Chim Acta. 2004. For age 15-18, a linear interpolation is used between
#' equations for <15 as described in Johanssen A et al. Ther Drug
#' Monit 2011. Predictions for age >18 are based on an linear regression 
#' built on open-source data (NHANES). Median height and weight imputed if not 
#' specified.
#'  
#'
#' @param sex sex, either `male` or `female`
#' @param age age in years
#' @param wt weight in kg (default 75 kg)
#' @param ht height in cm (default 165 cm)
#' @param digits number of digits to round to
#' @examples
#' calc_creat(sex = "male", age = 40)
#' calc_creat(sex = "male", age = 40, wt = 100, ht = 175)
#' calc_creat(sex = "male", age = c(10, 17, 60))
#' @export
calc_creat <- function (
  sex = NULL,
  age = NULL,
  wt = NULL,
  ht = NULL,
  digits = 1
  ) {
  if(is.null(sex) || !all(sex %in% c("male", "female"))) {
    stop("Sex needs to be either male or female!")
  }
  if(is.null(age)) {
    stop("Age required.")
  }
  if(is.null(wt) & any(age>18)) {
    warning("75 kg used: recommend specifying wt (kg)")
  }
  if(is.null(ht) & any(age>18)) {
    warning("165 cm used: recommend specifying ht (cm)")
  }
    scr <- rep(0, length(age))
    scr[age <= 15] <- -2.37330 -(12.91367 * log(age[age <= 15])) + 23.93581 * sqrt(age[age <= 15])
    sel1 <- (age > 15 & age < 18) & sex == "male"
    scr[sel1]   <- 9.5471 * age[sel1] - 87.847
    sel2 <- (age > 15 & age < 18) & sex == "female"
    scr[sel2] <- 4.7137 * age[sel2] - 15.347
    weight <-  ifelse(is.null(wt),75,wt)
    height <-ifelse(is.null(ht),165,ht)
    scr[age>18] <- (-0.1364288 + (0.0041581*age) + (0.1741357*ifelse(sex=="male",1,0)) + (0.0006403*weight) + (0.0039543*height)) * 88.4
  return(list(
    value = round(scr, digits),
    unit = "micromol/L"
  ))
}
