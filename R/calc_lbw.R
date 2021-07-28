#' Calculate lean body weight
#'
#' Get an estimate of lean body weight (LBW, in kg) based on weight, height, and sex.
#'
#' Note: technically not the same as fat-free mass, although difference is small.
#'
#' References:
#' `green`: Green and Duffull. Clin Pharmacol Ther 2002;
#' `james`: Absalom AR et al. Br J Anaesth 2009; 103:26-37.
#'          James W. Research on obesity. London: Her Majesty's Stationary Office, 1976.
#' `hume` : Hume R et al. J Clin Pathol. 1966 Jul; 19(4):389-91.
#' `boer` : Boer P et al. Am J Physiol 1984; 247: F632-5
#'
#' @param weight total body weight in kg
#' @param bmi bmi
#' @param height height in cm
#' @param sex sex, either `male` of `female`
#' @param method estimation method, either `green` (default), `boer`, `james`, `hume`
#' @param digits round to number of digits
#' @return Returns a list of the following elements:
#' \item{value}{Lean Body Weight (LBW) in units of kg}
#' \item{unit}{Unit describing LBW, (kg)}
#' @examples
#' calc_lbw(weight = 80, height = 170, sex = "male")
#' calc_lbw(weight = 80, height = 170, sex = "male", method = "james")
#' @export
calc_lbw <- function (
  weight = NULL,
  bmi = NULL,
  sex = NULL,
  height = NULL,
  method = "green",
  digits = 1) {
  methods <- c("green", "boer", "james", "hume")
  if(! method %in% methods) {
    stop(paste0("Unknown estimation method, please choose from: ", paste(methods, collapse=" ")))
  }
  if(is.null(sex) || !(sex %in% c("male", "female"))) {
    stop("Sex needs to be either male or female!")
  }
  if(method %in% c("boer", "james", "hume")) {
    if(is.null(weight) || is.null(height) || is.null(sex)) {
      stop("Equation needs weight, BMI or height, and sex of patient!")
    } else {
      if(method == "boer") {
        if(sex == "male") {
          lbm <-  0.407 * weight + 0.237 * height - 19.2
        } else {
          lbm <-  0.252 * weight + 0.473 * height - 48.3
        }
      }
      if(method == "hume") {
        if(sex == "male") {
          lbm <-  0.3281 * weight + 0.33929 * height - 29.5336
        } else {
          lbm <-  0.29569 * weight + 0.41813 * height - 43.2933
        }
      }
      if(method == "james") {
        if(sex == "male") {
          lbm <-  1.1 * weight - 128 * (weight/height)^2
        } else {
          lbm <-  1.07 * weight - 148 * (weight/height)^2
        }
      }
    }
  }
  if(method == "green") {
    if(is.null(weight) || (is.null(bmi) & is.null(height)) || is.null(sex)) {
      stop("Equation needs weight, BMI or height, and sex of patient!")
    } else {
      if(is.null(bmi)) {
        bmi <- calc_bmi(height = height, weight = weight)
      }
      if(sex == "male") {
        lbm <- (1.1 * weight) - 0.0128 * bmi * weight
      } else {
        lbm <- (1.07 * weight) - 0.0148 * bmi * weight
      }
    }
  }
  return(list(
    value = round(lbm,1),
    unit = "kg"
  ))
}
