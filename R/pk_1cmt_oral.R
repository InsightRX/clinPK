#' Concentration predictions for 1-compartmental oral PK model after single or multiple bolus doses
#'
#' @param t vector of time
#' @param dose dose
#' @param tau dosing interval
#' @param KA absorption rate
#' @param CL clearance
#' @param V volume of distribution
#' @param F bioavailability, commonly between 0 an 1.
#' @param ruv residual error (list)
#'
#' @references Garrett ER. The Bateman function revisited: a critical reevaluation of the quantitative expressions to characterize concentrations in the one compartment body model as a function of time with first-order invasion and first-order elimination. J Pharmacokinet Biopharm (1994) 22(2):103-128.
#' @references Bialer M. A simple method for determining whether absorption and elimination rate constants are equal in the one-compartment open model with first-order processes. J Pharmacokinet Biopharm (1980) 8(1):111-113
#' @references Nielsen JC, Hutmacher MM et al. J Pharmacokinet Pharmacodyn. 2012 Dec;39(6):619-34. doi: 10.1007/s10928-012-9274-0. Epub 2012 Sep 23.
#' @references https://static-content.springer.com/esm/art%3A10.1007%2Fs10928-012-9274-0/MediaObjects/10928_2012_9274_MOESM1_ESM.docx
#'
#' @examples
#' pk_1cmt_oral(dose = 500, tau = 12, CL = 5, V = 50, KA = 1)
#'
#' @export
pk_1cmt_oral <- function(
    t = c(0:24),
    dose = 100,
    tau = 12,
    KA = 1,
    CL = 3,
    V = 30,
    F = 1,
    ruv = NULL
  ) {
  k <- CL / V
  tmp <- c()
  dat <- data.frame(cbind(t = t, dv = 0))
  t_dos <- t %% tau
  n_dos <- floor(t/tau)
  unq_dos <- unique(n_dos) + 1
  if(KA == k) {
    Tmax <- 1/k
    Cmax <- F*dose / (V*exp(1))
    V_tmp <- F*dose / (Cmax * exp(1))
  }
  for(i in seq(unq_dos)) {
    sel <- n_dos >= i-1
    tmp <- dat[sel,]
    tmp$t <- tmp$t - (i-1)*tau
    if(KA == k) {
      tmp$dv <- (Cmax * exp(1) * tmp$t / Tmax) * exp(-tmp$t / Tmax)
    } else {
      tmp$dv <- (F*dose*KA/(V*(KA-k)))*(exp(-k*tmp$t) - exp(-KA*tmp$t))
    }
    dat[sel,]$dv <- dat[sel,]$dv + tmp$dv
  }
  if(!is.null(ruv)) {
    dat$dv <- add_ruv (dat$dv, ruv)
  }
  return(dat)
}
