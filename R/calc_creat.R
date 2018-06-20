#' Estimate serum creatinine
#'
#' Calculate an estimated serum creatinine. Function takes vectorized input as well.
#'
#' Uses equations described in Ceriotti et al. Clin Chem. 2008, and Junge W et al.
#' Clin Chim Acta. 2004. For age 15-18, a linear interpolation is used between
#' equations for <15 and >18 years as described in Johanssen A et al. Ther Drug
#' Monit 2011.
#'
#' @param sex sex, either `male` or `female`
#' @param age age in years
#' @param digits number of digits to round to
#' @examples
#' calc_creat(sex = "male", age = 40)
#' calc_creat(sex = "male", age = c(10, 17, 60))
#' @export
calc_creat <- function (
  sex = NULL,
  age = NULL,
  digits = 1
  ) {
  if(is.null(sex) || !all(sex %in% c("male", "female"))) {
    stop("Sex needs to be either male or female!")
  }
  if(is.null(age)) {
    stop("Age required.")
  }
  scr <- rep(0, length(age))
  scr[age <= 15] <- -2.37330 -(12.91367 * log(age[age <= 15])) + 23.93581 * sqrt(age[age <= 15])
  sel1 <- (age > 15 & age < 18) & sex == "male"
  scr[sel1]   <- 9.5471 * age[sel1] - 87.847
  sel2 <- (age > 15 & age < 18) & sex == "female"
  scr[sel2] <- 4.7137 * age[sel2] - 15.347
  scr[age >= 18 & sex == "male"]   <- 84
  scr[age >= 18 & sex == "female"] <- 69.5
  return(list(
    value = round(scr, digits),
    unit = "micromol/L"
  ))
}
