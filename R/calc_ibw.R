#' Calculate ideal body weight in kg for children and adults
#'
#' Get an estimate of ideal body weight. This function allows several commonly used equations
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
#' >= 18 years old (Devine equation)
#'   IBW (male) = 50 + (2.3 x height in inches over 5 feet)
#'   IBW (female) = 45.5 + (2.3 x height in inches over 5 feet)
#'
#' @param age age in years
#' @param weight weight in kg
#' @param height height in cm
#' @param sex sex
#' @param method_children method to use for children >1 and <18 years. Currently
#'   `"standard"` is the only method that is supported.
#' @param method_adults method to use for >=18 years. Currently `"devine"` is
#'   the only method that is supported (Devine BJ. Drug Intell Clin Pharm.
#'   1974;8:650-655).
#' @examples
#' calc_ibw(weight = 70, height = 170, age = 40, sex = "female")
#' calc_ibw(weight = 30, height = 140, age = 10, sex = "female")
#' @export
calc_ibw <- function (
  weight = NULL,
  height = NULL,
  age = NULL,
  sex = "male",
  method_children = "standard",
  method_adults = "devine"
) {
  method_children <- match.arg(method_children)
  method_adults <- match.arg(method_adults)
  if(is.null(age)) {
    stop("Age not specified!")
  }
  stopifnot(
    length(age) == 1,
    length(height) <= 1, # these are not always
    length(weight) <= 1, # required, so may be
    length(sex) <= 1     # NULL or length 1
  )

  ## babies
  if (age < 1) {
    if (is.null(weight)) {
      stop("Actual body weight is used as IBW for children < 1yr. Please supply a weight value.")
    }
    message("Note: using actual body weight as IBW for children < 1yr.")
    return(weight)
  }

  if (age >= 1 & age < 18) {
    ibw <- switch(
      method_children,
      "standard" = ibw_standard(age = age, height = height, sex = sex)
    )
  } else {
    ibw <- switch(
      method_adults,
      "devine" = ibw_devine(age = age, height = height, sex = sex)
    )
  }

  return(ibw)
}

#' Calculate IBW using "standard" equation
#'
#' @rdname calc_ibw
ibw_standard <- function(age, height = NULL, sex = NULL) {
  if (is.null(age) || age >= 18 || age < 1) {
    warning("Age should be >=1 and <18 for the `standard` method.")
  }
  if (is.null(height) || is.na(height)) {
    stop("Height is required to calculate IBW")
  }
  height_in <- cm2inch(height)
  if (height_in < 5 * 12) {
    return((height^2 * 1.65) / 1000)
  }
  if (is.null(sex) || is.na(sex)) {
    # Sex is only required if height >= 5ft, so this must come after the lines
    # above
    stop("Sex is required to calculate IBW when height is >= 5 feet")
  }
  if (!sex %in% c("male", "female")) {
    warning("The `standard` method for calculating IBW requires sex to be 'male' or 'female' for children 5 feet tall or taller.")
    return(NULL)
  }
  base_value <- switch(
    sex,
    "male" = 39,
    "female" = 42.2
  )
  height_inches_over_5_feet <- height_in - (5 * 12)
  base_value + (2.27 * height_inches_over_5_feet)
}

#' Calculate IBW using "devine" equation
#'
#' @rdname calc_ibw
ibw_devine <- function(age, height = NULL, sex = NULL) {
  if (age < 18) {
    warning("Age should be >18 for the `devine` method.")
  }
  if (is.null(height) || is.na(height) || is.null(sex) || is.na(sex)) {
    stop("Height and sex are required to calculate IBW")
  }
  if (!sex %in% c("male", "female")) {
    warning("The `devine` method for calculating IBW requires sex to be 'male' or 'female'.")
    return(NULL)
  }
  base_value <- switch(
    sex,
    "male" = 50,
    "female" = 45.5
  )
  height_in <- cm2inch(height)
  height_inches_over_5_feet <- height_in - (5 * 12)
  base_value + (2.3 * height_inches_over_5_feet)
}
