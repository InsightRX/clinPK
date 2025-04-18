% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/pk_1cmt_oral.R
\name{pk_1cmt_oral}
\alias{pk_1cmt_oral}
\title{Concentration predictions for 1-compartmental oral PK model after single or multiple bolus doses}
\usage{
pk_1cmt_oral(
  t = c(0:24),
  dose = 100,
  tau = 12,
  KA = 1,
  CL = 3,
  V = 30,
  F = 1,
  ruv = NULL
)
}
\arguments{
\item{t}{vector of time}

\item{dose}{dose}

\item{tau}{dosing interval}

\item{KA}{absorption rate}

\item{CL}{clearance}

\item{V}{volume of distribution}

\item{F}{bioavailability, commonly between 0 an 1.}

\item{ruv}{residual error (list)}
}
\description{
Concentration predictions for 1-compartmental oral PK model after single or multiple bolus doses
}
\examples{
pk_1cmt_oral(dose = 500, tau = 12, CL = 5, V = 50, KA = 1)

}
\references{
Garrett ER. The Bateman function revisited: a critical reevaluation of the quantitative expressions to characterize concentrations in the one compartment body model as a function of time with first-order invasion and first-order elimination. J Pharmacokinet Biopharm (1994) 22(2):103-128.

Bialer M. A simple method for determining whether absorption and elimination rate constants are equal in the one-compartment open model with first-order processes. J Pharmacokinet Biopharm (1980) 8(1):111-113

Nielsen JC, Hutmacher MM et al. J Pharmacokinet Pharmacodyn. 2012 Dec;39(6):619-34. doi: 10.1007/s10928-012-9274-0. Epub 2012 Sep 23.

https://static-content.springer.com/esm/art\%3A10.1007\%2Fs10928-012-9274-0/MediaObjects/10928_2012_9274_MOESM1_ESM.docx
}
