#' Calculate ideal body weight for children and adults
#'
#' Get an estimate of ideal body weight. This function allows several commonly used equations
#'
#' @param age age in years, can be vector
#' @param weight weight in kg, can be vector
#' @param height height in cm, can be vector
#' @param sex either `male` or `female`, can be vector
#' @param method_children method to use for children >1 and <18 years. Choose from `standard`, `mclaren` (McLaren DS, Read WWC. Lancet. 1972;2:146-148.), `moore` (Moore DJ et al. Nutr Res. 1985;5:797-799), `bmi` (), `ada` (American Dietary Association)
#' @param method_adults method to use for >=18 years. Choose from `devine` (default, Devine BJ. Drug Intell Clin Pharm. 1974;8:650-655).
#' @param digits number of decimals (can be NULL to for no rounding)
#'
#' Equations:
#'
#' <1yo Use actual body weight
#'
#' 1-17 years old ('standard'):
#'   if height < 5ft:
#'     IBW= (height in cm2 x 1.65)/1000
#'   if height > 5ft:
#'     IBW (male) = 39 + (2.27 x height in inches over 5 feet)
#'     IBW (female) = 42.2 + (2.27 x height in inches over 5 feet)
#'
#'   Methods not implemented yet:
#'   McLaren: IBW =
#'     - step1:   x = 50th percentile height for given age
#'     - step2: IBW = 50th percentile weight for x on weight-for-height scale
#'   Moore: IBW = weight at percentile x for given age, where x is percentile of height for given age
#'   BMI: IBW = 50th percentile of BMI for given age x (height in m)^2
#'   ADA: IBW = 50th percentile of WT for given age
#'
#' _ 18 years old (Devine equation)
#'   IBW (male) = 50 + (2.3 x height in inches over 5 feet)
#'   IBW (female) = 45.5 + (2.3 x height in inches over 5 feet)
#'
#' @export
calc_ibw <- function (
  weight = NULL,
  height = NULL,
  age = NULL,
  sex = "male",
  method_children = "standard",
  method_adults = "devine",
  digits = NULL
) {
  available_methods_children <- c("standard") # c("moore", "mclaren", "bmi", "ada")
  method_children <- tolower(method_children)
  if(!(method_children %in% available_methods_children)) {
    stop("Specified method for children not available.")
  }
  available_methods_adults <- c("devine")
  method_adults <- tolower(method_adults)
  if(!(method_adults %in% available_methods_adults)) {
    stop("Specified method for adults not available.")
  }
  if(is.null(age)) {
    stop("Age not specified!")
  }
  if(length(weight > 1)) {
    if(length(height) != length(weight)) {
      message("Height and weight do not have same vector lenght, using only first height.")
      height <- rep(height[1], length(weight))
    }
    if(length(age) != length(weight)) {
      message("Age and weight do not have same vector lenght, using only first age.")
      age <- rep(age[1], length(weight))
    }
    if(length(sex) != length(weight)) {
      message("Sex and weight do not have same vector lenght, using only first sex.")
      sex <- rep(sex[1], length(weight))
    }
  }

  ## babies
  ibw <- rep(0, length(weight))
  if(any(age < 1)) {
    message("Note: using actual body weight as IBW for children < 1yr.")
    ibw[age < 1] <- weight[age < 1]
  }

  ## children
  ht <- cm2inch(height)
  if(any(age >= 1 & age < 18)) {
    if(method_children == "standard") {
      if(any(is.null(height) || is.null(age) || is.null(sex))) {
        ibw[age >= 1 & age < 18 & (is.null(height) || is.null(age) || is.null(sex))] <- NA
        message("Height, age and sex are required!")
      }
      ibw[age >= 1 & age < 18 & ht < 5*12] <- (height[age >= 1 & age < 18 & ht < 5*12]^2 * 1.65)/1000
      ibw[age >= 1 & age < 18 & ht >= 5*12] <-
        (39   + 2.27 * (ht[age >= 1 & age < 18 & ht >= 5*12]-(5*12))) * (sex[age >= 1 & age < 18 & ht >= 5*12]=="male") +
        (42.2 + 2.27 * (ht[age >= 1 & age < 18 & ht >= 5*12]-(5*12))) * (sex[age >= 1 & age < 18 & ht >= 5*12]=="female")
    }
  }

  ## adults
  if(any(age >= 18)) {
    if(method_adults == "devine") {
      if(any(is.null(height) || is.null(sex))) {
        ibw[age >= 18 & (is.null(height) || is.null(sex))] <- NA
        message("Height and sex are required to calculate!")
      }
      ibw[age >= 18] <-
        (50 + (2.3 * (ht[age >= 18]-(5*12)))) * (sex[age >= 18] == "male") +
        (45.5 + (2.3 * (ht[age >= 18]-(5*12)))) * (sex[age >= 18] == "female")
    }
  }

  if(!is.null(digits)) {
    ibw <- round(ibw, digits=digits)
  }

  return(ibw)
}
