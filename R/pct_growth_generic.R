#' Vectorized growth percentiles for infants and children
#'
#' Calculate weight, height, and BMI growth percentiles for age/height for
#' infants and children using CDC Growth Charts data and equations.
#' 
#' @param weight A numeric vector of weights in kilograms.
#' @param height A numeric vector of heights in centimetres. For
#'   [pct_weight_for_height_v()], the units should match those specified in
#'   `height_units`.
#' @param bmi A numeric vector of BMI in kilograms/meters squared. 
#' @param age A numeric vector of ages in the unit specified in `age_units`.
#' @param age_units A character string specifying the units of all `age` values.
#' @param height_units A character string specifying the units of all `height`
#'   values for [pct_weight_for_height_v()].
#' @param sex A character vector specifying patient sex. Either `"male"` or
#'   `"female"`.
#' @param population A character string specifying the population table to use
#'   for [pct_weight_for_height_v()]. Either `"infants"` (birth to 36 months) or
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
#' pct_weight_for_age_v(weight = 20, age = 5, sex = "female")
#' 
#' # Set `return_numeric = FALSE` to return a data frame with additional info:
#' pct_weight_for_age_v(
#'   weight = 20, age = 5, sex = "female", return_numeric = FALSE
#' )
#' 
#' # Supply vectors of equal length to return information for each observation.
#' # This is particularly useful in calls to `dplyr::mutate()` or similar. 
#' pct_weight_for_age_v(
#'   weight = c(11, 7.2, 4.6, 4, 4.1),
#'   age = c(9.5, 6.1, 1.5, 2, 3),
#'   age_units = "months",
#'   sex = c("male", "female", "male", "male", "female")
#' )
pct_weight_for_age_v <- function(
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

#' @rdname pct_weight_for_age_v
#' @export
pct_height_for_age_v <- function(
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

#' @rdname pct_weight_for_age_v
#' @export
pct_bmi_for_age_v <- function(
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

#' @rdname pct_weight_for_age_v
#' @export
pct_weight_for_height_v <- function(
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

#' Median growth values for infants and children
#'
#' Calculate median weight, height, and BMI for age/height for infants and
#' children using CDC Growth Charts data and equations.
#' 
#' @inheritParams pct_weight_for_age_v
#' @param height A numeric vector of heights in the unit specified in `height_units`.
#' @param height_units A character string specifying the units of all `height` values.
#' @param population A character string specifying the population table to use
#'   for [median_weight_for_height()]. Either "infants" (birth to 36 months) or
#'   "children" (2 to 20 years).
#' 
#' @seealso Functions to calculate growth metrics: [pct_weight_for_age_v],
#'   [pct_height_for_age_v], [pct_bmi_for_age_v], [pct_weight_for_height_v]
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

#' Vectorized growth percentiles for infants and children (generic)
#'
#' Internal generic function to calculate weight/height/BMI growth percentiles
#' for age/height for infants and children using CDC Growth Charts data and
#' equations.
#' 
#' @param x A numeric vector of weights/heights/BMIs.
#' @param y A numeric vector of ages/heights in the unit specified in `y_units`.
#' @param growth_chart A CDC growth chart data frame (see [growth-charts]).
#' @param x_argname,y_argname A character string for naming the `x` and `y`
#'   arguments in relevant output.
#' @inheritParams pct_weight_for_age_v
#' @returns When `return_numeric = TRUE`, a vector of percentiles for the given
#'   physical measurement; when `return_numeric = FALSE`, a growth chart data
#'   frame.
#' @keywords internal
pct_growth_generic <- function(
    x, # observed value
    y, # x_for_y
    sex, # = c("male", "female")
    growth_chart,
    return_numeric = TRUE,
    return_median = FALSE,
    x_argname = "x",
    y_argname = "y",
    y_units = "raw"
) {
  if (missing(x) || missing(y) || missing(sex)) {
    stop(
      "`", x_argname, "`, ", "`", y_argname, "`, and", "`sex` ",
      "must all be specified."
    )
  }
  
  if (any(x < 0)) {
    stop("All `", x_argname, "` values must be positive.")
  }
  
  # The logic for this function expects the input values of `y` to match the
  # growth charts' units, which are months for age and centimetres for height.
  y_convert <- switch(
    y_units,
    raw = 1,
    # Age conversion factors:
    years = 12,
    months = 1,
    weeks = 0.230137,
    days = 0.0328767,
    # Height conversion factors:
    m = 100,
    metres = 100,
    cm = 1,
    centimetres = 1,
    ft = 30.48,
    feet = 30.48,
    "in" = 2.54,
    inches = 2.54
  )
  y <- y * y_convert
  
  # The `y` values for the growth charts always end in .5, so we can just use
  # the corresponding row if that is the case. The min and max values may be
  # integers, so we should check those too; they are always in the second
  # column.
  y_col <- names(growth_chart[2])
  y_min <- min(growth_chart[[y_col]])
  y_max <- max(growth_chart[[y_col]])
  y_out_of_range <- y < y_min | y > y_max
  if (any(y_out_of_range)) {
    # Back-convert the y_min and y_max units to be the same as the input for a
    # nicer error message.
    y_min <- y_min / y_convert
    y_max <- y_max / y_convert
    stop(
      "All `", y_argname, "` values must be between ", y_min, " and ", y_max,
      " ", y_units, "."
    )
  }
  y_exact_match <- (y - as.integer(y) == .5 | y == y_min | y == y_max)
  
  # It is better to remove the percentile columns from the growth chart so we
  # do not need to add NA values for these columns in the interpolated rows.
  pct_cols <- startsWith(names(growth_chart), "P")
  growth_chart <- growth_chart[, !pct_cols]
  
  # If the `y` values do not have an exact match, we need to interpolate values.
  out <- mapply(
    y, y_exact_match, sex,
    FUN = function(.y, .exact_match, .sex) {
      if (isFALSE(.exact_match)) {
        # For interpolation, just take the rows above and below the `y` value.
        # We know these will be .5 values or the `y_min` or `y_max` values, so
        # we do not need to crawl through every value in the `y` column.
        y_round <- round(.y)
        y_below <- ifelse(y_round == y_min, y_min, y_round - 0.5)
        y_above <- ifelse(y_round == y_max, y_max, y_round + 0.5) 
        sex_char <- ifelse(.sex == "male", 1, 2)
        growth_chart <- growth_chart[
          growth_chart$sex == sex_char & growth_chart[[y_col]] == y_below |
            growth_chart$sex == sex_char & growth_chart[[y_col]] == y_above,
        ]
        # After we have the rows above and below, we can linearly interpolate
        # the L, M, and S parameters for the `y` value and return only the
        # interpolated row to be passed to the growth curve equations.
        growth_chart_interp <- data.frame(
          sex = ifelse(.sex == "male", 1, 2),
          L = stats::approx(
            x = growth_chart[[y_col]], y = growth_chart$L, xout = .y
          )$y,
          M = stats::approx(
            x = growth_chart[[y_col]], y = growth_chart$M, xout = .y
          )$y,
          S = stats::approx(
            x = growth_chart[[y_col]], y = growth_chart$S, xout = .y
          )$y
        )
        growth_chart_interp[y_col] <- .y
        growth_chart_interp
      } else {
        # Otherwise we can return the exact match for the `y` value.
        sex_char <- ifelse(.sex == "male", 1, 2)
        growth_chart[growth_chart$sex == sex_char & growth_chart[[y_col]] == .y,]
      }
    },
    SIMPLIFY = FALSE
  )
  out <- Reduce(rbind, out)
  
  # Note: When `return_median = TRUE` it's fine if `x = NULL`.
  if (isTRUE(return_median)) {
    return(out$M)
  }
  
  out_for_p <- lms_for_z(l = out$L, m = out$M, s = out$S, x = x, value = "p")
  
  if (isTRUE(return_numeric)) {
    return(out_for_p)
  } else {
    out[[x_argname]] <- x
    out[[y_col]] <- out[[y_col]] / y_convert
    out$sex <- ifelse(out$sex == 1, "male", "female")
    out$P_obs <- out_for_p
    pct_cols <- c(
      P01 = .001, P1 = .01, P3 = .03, P5 = .05, P10 = .1, P15 = .15, P25 = .25,
      P50 = .5, P75 = .75, P85 = .85, P90 = .9, P95 = .95, P97 = .97, P99 = .99,
      P999 = .999
    )
    out_for_xp <- lapply(
      pct_cols, function(.p) lms_for_x(l = out$L, m = out$M, s = out$S, p = .p)
    )
    out <- cbind(out, out_for_xp)
    out <- out[, c("sex", x_argname, y_col, "L", "M", "S", "P_obs", names(out_for_xp))]
    return(out)
  }
}
