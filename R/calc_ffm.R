#' Calculate fat-free mass in kg
#'
#' Get an estimate of body-surface area based on weight, height, and sex (and age for Storset equation).
#'
#' References:
#' `janmahasatian`, `green`: Janmahasatian et al. Clin Pharmacokinet. 2005;44(10):1051-65)
#' `al-sallami`: Al-Sallami et al. Clin Pharmacokinet 2015
#' `storset`: Storset E et al. TDM 2016
#' `bucaloiu`: Bucaloiu ID et al. Int J of Nephrol Renovascular Dis. 2011 (Morbidly obese females)
#' `hume`: Hume R. J Clin Pathol 1966
#' `james`: James WPT et al. Research on obesity: a report of the DHSS/MRC Group 1976
#' `garrow_webster`: Garrow JS, Webster J. Quetelet's index (W/H2) as a measure of fatness. Int J Obesity 1984
#'
#' Overview:
#' - Sinha J, Duffull1 SB, Al-Sallami HS. Clin Pharmacokinet 2018. https://doi.org/10.1007/s40262-017-0622-5
#'
#' @param weight total body weight in kg
#' @param bmi BMI, only used in `green` method. If `weight` and `height` are both specified, `bmi` will be calculated on-the-fly.
#' @param height height in cm, only required for `holford` method, can be used instead of `bmi` for `green` method
#' @param sex sex, either `male` of `female`
#' @param age age, only used for Storset equation
#' @param method estimation method, either `green` (default), `holford`, or `storset`
#' @param digits round to number of digits
#' @return list of fat free mass in kg, unit (which is kg), and FFM method
#' @examples
#' calc_ffm(weight = 70, bmi = 25, sex = "male")
#' calc_ffm(weight = 70, height = 180, age = 40, sex = "female", method = "storset")
#' @export
calc_ffm <- function (
  weight = NULL,
  bmi = NULL,
  sex = NULL,
  height = NULL,
  age = NULL,
  method = "janmahasatian",
  digits = 1) {
  methods <- c("janmahasatian", "green", "al-sallami", "storset", "bucaloiu", "hume", "james", "garrow_webster")
  if(! method %in% methods) {
    stop(paste0("Unknown estimation method, please choose from: ", paste(methods, collapse=" ")))
  }
  if(is.null(sex) || !(sex %in% c("male", "female"))) {
    stop("Sex needs to be either male or female!")
  }
  sex <- tolower(sex)
  if(method %in% c("janmahasatian", "green")) {
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
  if(method == "bucaloiu") { # morbidly obese females
    if(is.null(weight) || is.null(height) || is.null(sex) || is.null(age)) {
      stop("Equation needs weight, height, sex, and age of patient!")
    } else {
      if(sex == "male") {
        stop("This equation is only meant for (obese) females.")
      } else {
        bmi <- calc_bmi(weight = weight, height = height)
        if(any(bmi < 25)) {
          warning("This equation is only meant for obese females.")
        }
        ffm <- -11.41 + 0.354 * weight + 11.06 * height/100
      }
    }
  }
  if(method == "hume") {
    if(is.null(weight) || is.null(height) || is.null(sex)) {
      stop("Equation needs weight, height, sex of patient!")
    } else {
      if(sex == "male") {
        ffm <- 0.3281 * weight + 0.33929 * height - 29.5336
      } else {
        ffm <- 0.29569 * weight + 0.41813 * height - 43.2933
      }
    }
  }
  if(method == "james") {
    if(is.null(weight) || is.null(height) || is.null(sex)) {
      stop("Equation needs weight, height, sex of patient!")
    } else {
      if(sex == "male") {
        ffm <- 1.1 * weight - 128*(weight/height)^2
      } else {
        ffm <- 1.07 * weight - 148*(weight/height)^2
      }
    }
  }
  if(method == "garrow_webster") {
    if(is.null(weight) || is.null(height) || is.null(sex)) {
      stop("Equation needs weight, height of patient!")
    } else {
      if(sex == "male") {
        ffm <- 0.285 * weight + 12.1*(height/100)^2
      } else {
        ffm <- 0.287 * weight + 9.74*(height/100)^2
      }
    }
  }
  return(list(
    value = round(ffm, digits),
    unit = "kg",
    method = tolower(method)
  ))
}
