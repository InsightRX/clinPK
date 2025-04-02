#' Growth percentiles for infants and children
#'
#' Calculate weight, height, and BMI growth percentiles for age/height for
#' infants and children using CDC Growth Charts data and equations.
#' 
#' @param weight A numeric vector of weights in kilograms.
#' @param height A numeric vector of heights in centimetres. For
#'   [pct_weight_for_height()], the units should match those specified in
#'   `height_units`.
#' @param bmi A numeric vector of BMI in kilograms/meters squared. 
#' @param age A numeric vector of ages in the unit specified in `age_units`.
#' @param age_units A character string specifying the units of all `age` values.
#' @param height_units A character string specifying the units of all `height`
#'   values for [pct_weight_for_height()].
#' @param sex A character vector specifying patient sex. Either `"male"` or
#'   `"female"`.
#' @param population A character string specifying the population table to use
#'   for [pct_weight_for_height()]. Either `"infants"` (birth to 36 months) or
#'   `"children"` (2 to 20 years).
#' @param return_numeric Return a numeric vector of percentiles for the given
#'   physical measurement? Defaults to `TRUE`. If `FALSE`, a data frame is
#'   returned with the observed percentile for the given physical measurement
#'   (`P_obs`), along with a select distribution of physical measurements at
#'   particular percentiles (`P01` to `P999`; the 0.1st to 99.9th percentiles).
#'
#' @seealso CDC Growth Charts data: [weight_for_age], [height_for_age],
#'   [bmi_for_age_children], [weight_for_height_infants],
#'   [weight_for_height_children]
#' @returns When `return_numeric = TRUE`, a vector of percentiles for the given
#'   physical measurement; when `return_numeric = FALSE`, a growth chart data
#'   frame.
#' @export
#'
#' @examples
#' # Returns a vector of percentiles for the given physical measurement:
#' pct_weight_for_age(weight = 20, age = 5, sex = "female")
#' 
#' # Set `return_numeric = FALSE` to return a data frame with additional info:
#' pct_weight_for_age(
#'   weight = 20, age = 5, sex = "female", return_numeric = FALSE
#' )
#' 
#' # Supply vectors of equal length to return information for each observation.
#' # This is particularly useful in calls to `dplyr::mutate()` or similar. 
#' pct_weight_for_age(
#'   weight = c(11, 7.2, 4.6, 4, 4.1),
#'   age = c(9.5, 6.1, 1.5, 2, 3),
#'   age_units = "months",
#'   sex = c("male", "female", "male", "male", "female")
#' )
pct_weight_for_age <- function(
    weight,
    age,
    age_units = c("years", "months", "weeks", "days"),
    sex,
    return_numeric = TRUE
) {
  age_units <- match.arg(age_units)
  sex <- match.arg(sex, choices = c("male", "female"), several.ok = TRUE)
  pct_growth_generic(
    x = weight,
    y = age,
    sex = sex,
    growth_chart = clinPK::weight_for_age,
    return_numeric = return_numeric,
    x_argname = "weight",
    y_argname = "age",
    y_units = age_units
  )
}

#' @rdname pct_weight_for_age
#' @export
pct_height_for_age <- function(
    height,
    age,
    age_units = c("years", "months", "weeks", "days"),
    sex,
    return_numeric = TRUE
) {
  age_units <- match.arg(age_units)
  sex <- match.arg(sex, choices = c("male", "female"), several.ok = TRUE)
  pct_growth_generic(
    x = height,
    y = age,
    sex = sex,
    growth_chart = clinPK::height_for_age,
    return_numeric = return_numeric,
    x_argname = "height",
    y_argname = "age",
    y_units = age_units
  )
}

#' @rdname pct_weight_for_age
#' @export
pct_bmi_for_age <- function(
    bmi,
    age,
    age_units = c("years", "months", "weeks", "days"),
    sex,
    return_numeric = TRUE
) {
  age_units <- match.arg(age_units)
  sex <- match.arg(sex, choices = c("male", "female"), several.ok = TRUE)
  pct_growth_generic(
    x = bmi,
    y = age,
    sex = sex,
    growth_chart = clinPK::bmi_for_age_children,
    return_numeric = return_numeric,
    x_argname = "bmi",
    y_argname = "age",
    y_units = age_units
  )
}

#' @rdname pct_weight_for_age
#' @export
pct_weight_for_height <- function(
    weight,
    height,
    height_units = c("centimetres", "metres", "feet", "inches"),
    sex,
    population = c("infants", "children"),
    return_numeric = TRUE
) {
  population <- match.arg(population)
  if (population == "infants") {
    growth_chart <- clinPK::weight_for_height_infants
  } else if (population == "children") {
    growth_chart <- clinPK::weight_for_height_children
  }
  height_units <- match.arg(height_units)
  sex <- match.arg(sex, choices = c("male", "female"), several.ok = TRUE)
  pct_growth_generic(
    x = weight,
    y = height,
    sex = sex,
    growth_chart = growth_chart,
    return_numeric = return_numeric,
    x_argname = "weight",
    y_argname = "height",
    y_units = height_units
  )
}
