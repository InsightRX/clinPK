% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/pct_growth_generic.R
\name{pct_growth_generic}
\alias{pct_growth_generic}
\title{Vectorized growth percentiles for infants and children (generic)}
\usage{
pct_growth_generic(
  x,
  y,
  sex,
  growth_chart,
  return_numeric = TRUE,
  return_median = FALSE,
  x_argname = "x",
  y_argname = "y",
  y_units = "raw"
)
}
\arguments{
\item{x}{A numeric vector of weights/heights/BMIs.}

\item{y}{A numeric vector of ages/heights in the unit specified in \code{y_units}.}

\item{sex}{A character vector specifying patient sex. Either \code{"male"} or
\code{"female"}.}

\item{growth_chart}{A CDC growth chart data frame (see \link{growth-charts}).}

\item{return_numeric}{Return a numeric vector of percentiles for the given
physical measurement? Defaults to \code{TRUE}. If \code{FALSE}, a data frame is
returned with the observed percentile for the given physical measurement
(\code{P_obs}), along with a select distribution of physical measurements at
particular percentiles (\code{P01} to \code{P999}; the 0.1st to 99.9th percentiles).}

\item{x_argname, y_argname}{A character string for naming the \code{x} and \code{y}
arguments in relevant output.}
}
\value{
When \code{return_numeric = TRUE}, a vector of percentiles for the given
physical measurement; when \code{return_numeric = FALSE}, a growth chart data
frame.
}
\description{
Internal generic function to calculate weight/height/BMI growth percentiles
for age/height for infants and children using CDC Growth Charts data and
equations.
}
\keyword{internal}
