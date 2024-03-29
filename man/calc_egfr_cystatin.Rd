% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/calc_egfr_cystatin.R
\name{calc_egfr_cystatin}
\alias{calc_egfr_cystatin}
\title{Calculate eGFR based on Cystatin C measurements}
\usage{
calc_egfr_cystatin(
  cystatin = NULL,
  cystatin_unit = "mg/L",
  method = c("grubb", "larsson", "hoek"),
  unit_out = c("ml/min", "ml/hr", "l/min", "l/hr", "ml/min/1.73m2")
)
}
\arguments{
\item{cystatin}{serum cystatin concentration (mg/L)}

\item{cystatin_unit, }{only `mg/L` available}

\item{method}{eGFR estimation method, choose from `grubb`, `larsson`, `hoek`}

\item{unit_out}{eGFR output unit, choose from `ml/min`, `ml/hr`, `l/min`, `l/hr`}
}
\description{
Calculate eGFR based on Cystatin C measurements
}
\examples{
calc_egfr_cystatin(1.0)
calc_egfr_cystatin(1.0, method = "larsson")
calc_egfr_cystatin(1.0, unit_out = "l/hr")
}
