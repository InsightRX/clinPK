#' Median growth values for infants and children
#'
#' Calculate median weight, height, and BMI for age/height for infants and
#' children using CDC Growth Charts data and equations.
#' 
#' @inheritParams pct_weight_for_age
#' @param height A numeric vector of heights in the unit specified in `height_units`.
#' @param height_units A character string specifying the units of all `height` values.
#' @param population A character string specifying the population table to use
#'   for [median_weight_for_height()]. Either "infants" (birth to 36 months) or
#'   "children" (2 to 20 years).
#' 
#' @seealso Functions to calculate growth metrics: [pct_weight_for_age],
#'   [pct_height_for_age], [pct_bmi_for_age], [pct_weight_for_height]
#'
#' CDC Growth Charts data: [weight_for_age], [height_for_age],
#' [bmi_for_age_children], [weight_for_height_infants],
#' [weight_for_height_children]
#' @returns A numeric vector of median weight, height, or BMI values for the
#'   given ages/heights.
#' @export
#'
#' @examples
#' median_weight_for_age(3.5, "months", sex = "male")
median_weight_for_age <- function(
    age,
    age_units = c("years", "months", "weeks", "days"),
    sex
) {
  age_units <- match.arg(age_units)
  sex <- match.arg(sex, choices = c("male", "female"), several.ok = TRUE)
  pct_growth_generic(
    x = NULL,
    y = age,
    sex = sex,
    growth_chart = clinPK::weight_for_age,
    return_median = TRUE,
    y_argname = "age",
    y_units = age_units
  )
}

#' @rdname median_weight_for_age
#' @export
median_height_for_age <- function(
    age,
    age_units = c("years", "months", "weeks", "days"),
    sex
) {
  age_units <- match.arg(age_units)
  sex <- match.arg(sex, choices = c("male", "female"), several.ok = TRUE)
  pct_growth_generic(
    x = NULL,
    y = age,
    sex = sex,
    growth_chart = clinPK::height_for_age,
    return_median = TRUE,
    y_argname = "age",
    y_units = age_units
  )
}

#' @rdname median_weight_for_age
#' @export
median_bmi_for_age <- function(
    age,
    age_units = c("years", "months", "weeks", "days"),
    sex
) {
  age_units <- match.arg(age_units)
  sex <- match.arg(sex, choices = c("male", "female"), several.ok = TRUE)
  pct_growth_generic(
    x = NULL,
    y = age,
    sex = sex,
    growth_chart = clinPK::bmi_for_age_children,
    return_median = TRUE,
    y_argname = "age",
    y_units = age_units
  )
}

#' @rdname median_weight_for_age
#' @export
median_weight_for_height <- function(
    height,
    height_units = c("centimetres", "metres", "feet", "inches"),
    sex,
    population = c("infants", "children")
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
    x = NULL,
    y = height,
    sex = sex,
    growth_chart = growth_chart,
    return_median = TRUE,
    y_argname = "height",
    y_units = height_units
  )
}
