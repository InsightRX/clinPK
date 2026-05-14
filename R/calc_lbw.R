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
calc_lbw <- function(
  weight = NULL,
  bmi = NULL,
  sex = NULL,
  height = NULL,
  method = c("green", "boer", "james", "hume"),
  digits = 1
) {
  check_input_lengths(sex = sex, weight = weight, height = height, bmi = bmi)
  method <- match.arg(method)
  method_fn <- switch(method,
    "green" = lbw_green,
    "boer"  = lbw_boer,
    "james" = lbw_james,
    "hume"  = lbw_hume
  )

  inputs <- prepare_method_inputs(method_fn, method,
    weight = weight, bmi = bmi, sex = sex, height = height
  )

  inputs$sex <- normalize_sex(inputs$sex)
  if (is.null(inputs$sex)) return(NULL)

  lbw <- do.call(method_fn, inputs[intersect(names(inputs), formalArgs(method_fn))])

  return(list(
    value = round(lbw, digits),
    unit = "kg"
  ))
}

lbw_green <- function(weight, sex, bmi) {
  ifelse(
    sex == "male",
    (1.1  * weight) - 0.0128 * bmi * weight,
    (1.07 * weight) - 0.0148 * bmi * weight
  )
}

lbw_boer <- function(weight, sex, height) {
  ifelse(
    sex == "male",
    0.407 * weight + 0.267 * height - 19.2,
    0.252 * weight + 0.473 * height - 48.3
  )
}

lbw_james <- function(weight, sex, height) {
  ifelse(
    sex == "male",
    1.1  * weight - 128 * (weight / height)^2,
    1.07 * weight - 148 * (weight / height)^2
  )
}

lbw_hume <- function(weight, sex, height) {
  ifelse(
    sex == "male",
    0.3281  * weight + 0.33929 * height - 29.5336,
    0.29569 * weight + 0.41813 * height - 43.2933
  )
}
