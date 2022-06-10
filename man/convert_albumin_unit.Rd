% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/convert_albumin_unit.R
\name{convert_albumin_unit}
\alias{convert_albumin_unit}
\title{Convert albumin from / to units}
\usage{
convert_albumin_unit(value = NULL, from = NULL, to)
}
\arguments{
\item{value}{albumin measurements}

\item{from}{from unit, e.g. `"g_l"`.}

\item{to}{to flow unit, e.g. `"g_dl"`}
}
\description{
Accepted units are "g_l" or "g_dl". Arguments supplied to `value` and `from`
units must be of the same length. "To" unit must be of length 1.
}
\examples{

## single values
convert_albumin_unit(0.6, "g_dl", "g_l")

## vectorized
convert_albumin_unit(
  c(0.4, 2, 0.3), 
  from = c("g_dl", "g_l", "g_dl"), 
  to = c("g_l") 
)
  
}