% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/calc_kel_double_tdm.R
\name{calc_kel_double_tdm}
\alias{calc_kel_double_tdm}
\title{Calculate elimination rate when given two TDM samples}
\usage{
calc_kel_double_tdm(
  dose = 1000,
  t = c(2, 11.5),
  dv = c(30, 10),
  tau = 12,
  t_inf = 1,
  V = NULL,
  steady_state = TRUE,
  return_parameters = FALSE
)
}
\arguments{
\item{dose}{dose amount}

\item{t}{time or time after dose, vector of size 2}

\item{dv}{observed value, vector of size 2}

\item{tau}{dosing interval}

\item{t_inf}{infusion time}

\item{V}{if specified, use that (empiric) value and don't estimate from data. Default \code{NULL}.}

\item{steady_state}{samples taken at steady state? Only influences AUCtau.}

\item{return_parameters}{return all parameters instead of only kel?}
}
\description{
Calculate elimination rate when given two TDM samples
}
\examples{
calc_kel_double_tdm(dose = 1000, t = c(3, 18), dv = c(30, 10))

}
