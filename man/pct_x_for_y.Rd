% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/pct_x_for_y.R
\name{pct_x_for_y}
\alias{pct_x_for_y}
\alias{pct_weight_for_age}
\alias{pct_height_for_age}
\alias{pct_bmi_for_age}
\alias{pct_weight_for_height}
\title{Growth percentiles for infants and children}
\usage{
pct_weight_for_age(
  weight,
  age,
  age_units = c("years", "months", "weeks", "days"),
  sex,
  return_numeric = TRUE
)

pct_height_for_age(
  height,
  age,
  age_units = c("years", "months", "weeks", "days"),
  sex,
  return_numeric = TRUE
)

pct_bmi_for_age(
  bmi,
  age,
  age_units = c("years", "months", "weeks", "days"),
  sex,
  return_numeric = TRUE
)

pct_weight_for_height(
  weight,
  height,
  height_units = c("centimetres", "metres", "feet", "inches"),
  sex,
  population = c("infants", "children"),
  return_numeric = TRUE
)
}
\arguments{
\item{weight}{A numeric vector of weights in kilograms.}

\item{age}{A numeric vector of ages in the unit specified in \code{age_units}.}

\item{age_units}{A character string specifying the units of all \code{age} values.}

\item{sex}{A character vector specifying patient sex. Either \code{"male"} or
\code{"female"}.}

\item{return_numeric}{Return a numeric vector of percentiles for the given
physical measurement? Defaults to \code{TRUE}. If \code{FALSE}, a data frame is
returned with the observed percentile for the given physical measurement
(\code{P_obs}), along with a select distribution of physical measurements at
particular percentiles (\code{P01} to \code{P999}; the 0.1st to 99.9th percentiles).}

\item{height}{A numeric vector of heights in centimetres. For
\code{\link[=pct_weight_for_height]{pct_weight_for_height()}}, the units should match those specified in
\code{height_units}.}

\item{bmi}{A numeric vector of BMI in kilograms/meters squared.}

\item{height_units}{A character string specifying the units of all \code{height}
values for \code{\link[=pct_weight_for_height]{pct_weight_for_height()}}.}

\item{population}{A character string specifying the population table to use
for \code{\link[=pct_weight_for_height]{pct_weight_for_height()}}. Either \code{"infants"} (birth to 36 months) or
\code{"children"} (2 to 20 years).}
}
\value{
When \code{return_numeric = TRUE}, a vector of percentiles for the given
physical measurement; when \code{return_numeric = FALSE}, a growth chart data
frame.
}
\description{
Calculate weight, height, and BMI growth percentiles for age/height for
infants and children using CDC Growth Charts data and equations.
}
\examples{
# Returns a vector of percentiles for the given physical measurement:
pct_weight_for_age(weight = 20, age = 5, sex = "female")

# Set `return_numeric = FALSE` to return a data frame with additional info:
pct_weight_for_age(
  weight = 20, age = 5, sex = "female", return_numeric = FALSE
)

# Supply vectors of equal length to return information for each observation.
# This is particularly useful in calls to `dplyr::mutate()` or similar. 
pct_weight_for_age(
  weight = c(11, 7.2, 4.6, 4, 4.1),
  age = c(9.5, 6.1, 1.5, 2, 3),
  age_units = "months",
  sex = c("male", "female", "male", "male", "female")
)
}
\seealso{
CDC Growth Charts data: \link{weight_for_age}, \link{height_for_age},
\link{bmi_for_age_children}, \link{weight_for_height_infants},
\link{weight_for_height_children}
}
