#' Convert AUCtau or AUCt to dose (for 1-compartment linear PK model)
#'
#' @param auc AUCtau
#' @param CL Clearance
#' @param V Volume of distribution
#' @param t_auc if AUCtau is not known but only AUCt, `t_auc` specifies time until which AUC_t is calculated to be able to calculate dose
#' @examples
#' auc2dose(450, CL = 5, V = 50)
#' @export
auc2dose <- function(auc, CL, V, t_auc = NA) {
  dose_inf <- as.numeric(auc * CL)
  if (!is.na(t_auc)) {
    k <- CL / V
    frac <- 1 - exp(-k * t_auc)
    return(as.numeric(dose_inf / frac))
  } else {
    return(dose_inf)
  }
}
