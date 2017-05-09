#' Calculate fat-free mass
#'
#' Get an estimate of body-surface area based on weight, height, and sex (and age for Storset equation).
#'
#' References:
#' `green`: Janmahasatian et al. Clin Pharmacokinet. 2005;44(10):1051-65)
#' `al-sallami`: Al-Sallami et al. Clin Pharmacokinet 2015
#' `storset`: Storset E et al. TDM 2016
#'
#' @param weight total body weight in kg
#' @param bmi BMI, only used in `green` method. If `weight` and `height` are both specified, `bmi` will be calculated on-the-fly.
#' @param height height in cm, only required for `holford` method, can be used instead of `bmi` for `green` method
#' @param sex sex, either `male` of `female`
#' @param age age, only used for Storset equation
#' @param method estimation method, either `green` (default), `holford`, or `storset`
#' @param digits round to number of digits
#' @export
calc_ffm <- function (
  weight = NULL,
  bmi = NULL,
  sex = NULL,
  height = NULL,
  age = NULL,
  method = "green",
  digits = 1) {
  methods <- c("green", "al-sallami", "storset")
  if(! method %in% methods) {
    stop(paste0("Unknown estimation method, please choose from: ", paste(methods, collapse=" ")))
  }
  if(is.null(sex) || !(sex %in% c("male", "female"))) {
    stop("Sex needs to be either male or female!")
  }
  if(method == "green") {
    if(is.null(weight) || (is.null(bmi) & is.null(height)) || is.null(sex)) {
      stop("Equation needs weight, BMI or height, and sex of patient!")
    } else {
      if(is.null(bmi)) {
        bmi <- calc_bmi(height = height, weight = weight)
      }
      if(sex == "male") {
        ffm <- (9.27e03 * weight) / ((6.68e03) + 216 * bmi)
      } else {
        ffm <- (9.27e03 * weight) / ((8.78e03) + 244 * bmi)
      }
    }
  }
  if(method == "al-sallami") {
    if(is.null(weight) || (is.null(bmi) & is.null(height)) || is.null(sex) || is.null(age)) {
      stop("Equation needs weight, BMI or height, and sex of patient!")
    }
    if(is.null(bmi)) {
      bmi <- calc_bmi(weight = weight, height = height)
    }
    if(sex == "female") {
      ffm <- (1.11 + ((1-1.11)/(1+(age/7.1)^-1.1))) * ((9270 * weight)/(8780 + (244 * bmi)))
    } else {
      ffm <- (0.88 + ((1-0.88)/(1+(age/13.4)^-12.7))) * ((9270 * weight)/(6680 + (216 * bmi)))
    }
  }
  if(method == "storset") { # based on kidney transplant patient
    if(is.null(weight) || is.null(height) || is.null(sex) || is.null(age)) {
      stop("Equation needs weight, height, sex, and age of patient!")
    } else {
      if(sex == "male") {
        ffm <- (11.4 * weight) / (81.3 + weight) * (1 + height * 0.052) * (1-age*0.0007)
      } else {
        ffm <- (10.2 * weight) / (81.3 + weight) * (1 + height * 0.052) * (1-age*0.0007)
      }
    }
  }
  return(list(
    value = round(ffm, digits),
    unit = "kg",
    method = tolower(method)
  ))
}
