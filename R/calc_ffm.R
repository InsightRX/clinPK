#' Calculate fat-free mass
#'
#' Get an estimate of fat-free mass (FFM, in kg) based on weight, height, and sex (and age for Storset equation).
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
#' @param method estimation method, one of `janmahasatian` (default), `green`, `al-sallami`, `storset`, `bucaloiu`, `hume`, `james`, or `garrow_webster`.
#' @param digits round to number of digits
#' @return Returns a list of the following elements:
#' \item{value}{Fat-free Mass (FFM) in units of kg}
#' \item{unit}{Unit describing FFM, (kg)}
#' \item{method}{Method used to calculate FFF}
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
  method = c("janmahasatian", "green", "al-sallami", "storset", "bucaloiu", "hume", "james", "garrow_webster"),
  digits = 1) {
  method <- match.arg(method)
  sex <- tolower(sex)

  ffm <- switch(
    method,
    "janmahasatian" = ffm_janmahasatian_green(
      weight = weight,
      sex = sex,
      height = height,
      bmi = bmi
    ),
    "green" = ffm_janmahasatian_green(
      weight = weight,
      sex = sex,
      height = height,
      bmi = bmi
    ),
    "al-sallami" = ffm_al_sallami(
      weight = weight,
      sex = sex,
      age = age,
      height = height,
      bmi = bmi
    ),
    "storset" = ffm_storset( # based on kidney transplant patient
      weight = weight,
      sex = sex,
      height = height,
      age = age
    ),
    "bucaloiu" = ffm_bucaloiu( # morbidly obese females
      weight = weight,
      height = height,
      sex = sex,
      age = age
    ),
    "hume" = ffm_hume(weight = weight, height = height, sex = sex),
    "james" = ffm_james(weight = weight, height = height, sex = sex),
    "garrow_webster" = ffm_garrow_webster(
      weight = weight,
      height = height,
      sex = sex
    )
  )

  return(list(
    value = round(ffm, digits),
    unit = "kg",
    method = tolower(method)
  ))
}

ffm_janmahasatian_green <- function(weight, sex, height = NULL, bmi = NULL) {
  if(is.null(weight) || (is.null(bmi) & is.null(height)) || is.null(sex)) {
    stop("Equation needs weight, BMI or height, and sex of patient!")
  }
  if (!sex %in% c("male", "female")) {
    warning("This method requires sex to be one of 'male' or 'female'.")
    return(NULL)
  }
  if(is.null(bmi)) {
    bmi <- calc_bmi(height = height, weight = weight)
  }
  if(sex == "male") {
    ffm <- (9.27e03 * weight) / ((6.68e03) + 216 * bmi)
  } else {
    ffm <- (9.27e03 * weight) / ((8.78e03) + 244 * bmi)
  }
  ffm
}

ffm_al_sallami <- function(weight, sex, age, height = NULL, bmi = NULL) {
  if(is.null(weight) || (is.null(bmi) & is.null(height)) || is.null(sex) || is.null(age)) {
    stop("Equation needs weight, BMI or height, sex, and age of patient!")
  }
  if (!sex %in% c("male", "female")) {
    warning("This method requires sex to be one of 'male' or 'female'.")
    return(NULL)
  }
  if(is.null(bmi)) {
    bmi <- calc_bmi(weight = weight, height = height)
  }
  if(sex == "female") {
    ffm <- (1.11 + ((1-1.11)/(1+(age/7.1)^-1.1))) * ((9270 * weight)/(8780 + (244 * bmi)))
  } else {
    ffm <- (0.88 + ((1-0.88)/(1+(age/13.4)^-12.7))) * ((9270 * weight)/(6680 + (216 * bmi)))
  }
  ffm
}

ffm_storset <- function(weight, sex, height, age) {
  if(is.null(weight) || is.null(height) || is.null(sex) || is.null(age)) {
    stop("Equation needs weight, height, sex, and age of patient!")
  }
  if (!sex %in% c("male", "female")) {
    warning("This method requires sex to be one of 'male' or 'female'.")
    return(NULL)
  }
  if(sex == "male") {
    ffm <- (11.4 * weight) / (81.3 + weight) * (1 + height * 0.052) * (1-age*0.0007)
  } else {
    ffm <- (10.2 * weight) / (81.3 + weight) * (1 + height * 0.052) * (1-age*0.0007)
  }
  ffm
}

ffm_bucaloiu <- function(weight, sex, height, age) {
  if(is.null(weight) || is.null(height) || is.null(sex) || is.null(age)) {
    stop("Equation needs weight, height, sex, and age of patient!")
  }
  bmi <- calc_bmi(weight = weight, height = height)
  if(any(bmi < 25) || !sex == "female") {
    warning("This equation is only meant for obese females.")
  }
  ffm <- -11.41 + 0.354 * weight + 11.06 * height/100
  ffm
}

ffm_hume <- function(weight, sex, height) {
  if(is.null(weight) || is.null(height) || is.null(sex)) {
    stop("Equation needs weight, height, sex of patient!")
  }
  if (!sex %in% c("male", "female")) {
    warning("This method requires sex to be one of 'male' or 'female'.")
    return(NULL)
  }
  if(sex == "male") {
    ffm <- 0.3281 * weight + 0.33929 * height - 29.5336
  } else {
    ffm <- 0.29569 * weight + 0.41813 * height - 43.2933
  }
  ffm
}

ffm_james <- function(weight, sex, height) {
  if(is.null(weight) || is.null(height) || is.null(sex)) {
    stop("Equation needs weight, height, sex of patient!")
  }
  if (!sex %in% c("male", "female")) {
    warning("This method requires sex to be one of 'male' or 'female'.")
    return(NULL)
  }
  if(sex == "male") {
    ffm <- 1.1 * weight - 128*(weight/height)^2
  } else {
    ffm <- 1.07 * weight - 148*(weight/height)^2
  }
  ffm
}

ffm_garrow_webster <- function(weight, sex, height) {
  if(is.null(weight) || is.null(height) || is.null(sex)) {
    stop("Equation needs weight, height, and sex of patient!")
  }
  if (!sex %in% c("male", "female")) {
    warning("This method requires sex to be one of 'male' or 'female'.")
    return(NULL)
  }
  if(sex == "male") {
    ffm <- 0.285 * weight + 12.1*(height/100)^2
  } else {
    ffm <- 0.287 * weight + 9.74*(height/100)^2
  }
  ffm
}
