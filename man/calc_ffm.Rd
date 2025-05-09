% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/calc_ffm.R
\name{calc_ffm}
\alias{calc_ffm}
\title{Calculate fat-free mass}
\usage{
calc_ffm(
  weight = NULL,
  bmi = NULL,
  sex = NULL,
  height = NULL,
  age = NULL,
  method = c("janmahasatian", "green", "al-sallami", "storset", "bucaloiu", "hume",
    "james", "garrow_webster"),
  digits = 1
)
}
\arguments{
\item{weight}{total body weight in kg}

\item{bmi}{BMI, only used in \code{green} method. If \code{weight} and \code{height} are both specified, \code{bmi} will be calculated on-the-fly.}

\item{sex}{sex, either \code{male} of \code{female}}

\item{height}{height in cm, only required for \code{holford} method, can be used instead of \code{bmi} for \code{green} method}

\item{age}{age, only used for Storset equation}

\item{method}{estimation method, one of \code{janmahasatian} (default), \code{green}, \code{al-sallami}, \code{storset}, \code{bucaloiu}, \code{hume}, \code{james}, or \code{garrow_webster}.}

\item{digits}{round to number of digits}
}
\value{
Returns a list of the following elements:
\item{value}{Fat-free Mass (FFM) in units of kg}
\item{unit}{Unit describing FFM, (kg)}
\item{method}{Method used to calculate FFF}
}
\description{
Get an estimate of fat-free mass (FFM, in kg) based on weight, height, and sex (and age for Storset equation).
}
\details{
References:
\code{janmahasatian}, \code{green}: Janmahasatian et al. Clin Pharmacokinet. 2005;44(10):1051-65)
\code{al-sallami}: Al-Sallami et al. Clin Pharmacokinet 2015
\code{storset}: Storset E et al. TDM 2016
\code{bucaloiu}: Bucaloiu ID et al. Int J of Nephrol Renovascular Dis. 2011 (Morbidly obese females)
\code{hume}: Hume R. J Clin Pathol 1966
\code{james}: James WPT et al. Research on obesity: a report of the DHSS/MRC Group 1976
\code{garrow_webster}: Garrow JS, Webster J. Quetelet's index (W/H2) as a measure of fatness. Int J Obesity 1984

Overview:
\itemize{
\item Sinha J, Duffull1 SB, Al-Sallami HS. Clin Pharmacokinet 2018. https://doi.org/10.1007/s40262-017-0622-5
}
}
\examples{
calc_ffm(weight = 70, bmi = 25, sex = "male")
calc_ffm(weight = 70, height = 180, age = 40, sex = "female", method = "storset")
}
