#' Estimate serum creatinine
#'
#' Calculate an estimated serum creatinine. Function takes vectorized input as well.
#'
#' For children and adolescents: Uses equations described in Ceriotti et al. 
#' Clin Chem. 2008, and Junge W et al. Clin Chim Acta. 2004. For age 15-18, 
#' a linear interpolation is used between equations for <15 Johanssen A et al. 
#' Ther Drug Monit 2011.
#' For adults:  Two methods are available Johanssen et al. Ther Drug Monit 2011.
#' which describes a flat serum creatinine dependent on sex, and Brooks et al 
#' (unpublished) which is a linear regression built on the NHANES open-source
#' data and takes into account sex, age, weight, and height. Equation: lm(SCr~Age+Sex+Weight+Height, data=NHANES)
#'
#'
#' @param sex sex, either `male` or `female`
#' @param age age in years
#' @param weight weight in kg (default 75 kg)
#' @param height height in cm (default 165 cm)
#' @param adult_method estimation adult method, `johanssen` (default) or `brooks`,
#' @param digits number of digits to round to
#' @examples
#' calc_creat(sex = "male", age = 40)
#' calc_creat(sex = "male", age = 40, wt = 100, ht = 175, method="Brooks)
#' calc_creat(sex = "male", age = c(10, 17, 60))
#' @export
calc_creat <- function (
  sex = NULL,
  age = NULL,
  weight = NULL,
  height = NULL,
  adult_method = c("johanssen", "brooks"),
  digits = 1 ) {
  adult_method <- match.arg(adult_method)
  scr <- switch(
    adult_method,
    "johanssen" = calc_creat_johanssen(
      age = age,
      sex = sex,
      adult_method=adult_method
    ),
    "brooks" = calc_creat_brooks(
      age = age,
      sex = sex,
      weight = weight,
      height = height,
      adult_method=adult_method
    )
  )
  return(list(
    value = round(scr, digits),
    unit = "micromol/L",
    method = tolower(adult_method)
  ))
  calc_creat_johanssen <- function(age, sex, adult_method) {
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
    scr
  }
  calc_creat_brooks <- function(age, sex, weight, height, adult_method) {
  if(is.null(sex) || !all(sex %in% c("male", "female"))) {
    stop("Sex needs to be either male or female!")
  }
  if(is.null(age)) {
    stop("Age required.")
  }
  if(is.null(weight) && adult_method == "brooks") {
    stop("Weight is required")
  }
  if(is.null(height) && adult_method == "brooks") {
    stop("Height is required")
  }
    scr <- rep(0, length(age))
    scr[age <= 15] <- -2.37330 -(12.91367 * log(age[age <= 15])) + 23.93581 * sqrt(age[age <= 15])
    sel1 <- (age > 15 & age < 18) & sex == "male"
    scr[sel1]   <- 9.5471 * age[sel1] - 87.847
    sel2 <- (age > 15 & age < 18) & sex == "female"
    scr[sel2] <- 4.7137 * age[sel2] - 15.347
    scr[age>18] <- (-0.1364288 + (0.0041581*age) + (0.1741357*ifelse(sex=="male",1,0)) + (0.0006403*weight) + (0.0039543*height)) * 88.4
    scr
  }
}

