% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/auc2dose.R
\name{auc2dose}
\alias{auc2dose}
\title{Convert AUCtau or AUCt to dose (for 1-compartment linear PK model)}
\usage{
auc2dose(auc, CL, V, t_auc = NA)
}
\arguments{
\item{auc}{AUCtau}

\item{CL}{Clearance}

\item{V}{Volume of distribution}

\item{t_auc}{if AUCtau is not known but only AUCt, \code{t_auc} specifies time until which AUC_t is calculated to be able to calculate dose}
}
\description{
Convert AUCtau or AUCt to dose (for 1-compartment linear PK model)
}
\examples{
auc2dose(450, CL = 5, V = 50)
}
