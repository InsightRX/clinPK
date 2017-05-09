#' Convert dose to expected AUCtau or AUCt for 1 compartment linear PK model
#'
#' @param dose dose amount
#' @param CL Clearance
#' @param V Volume of distribution
#' @param t_auc if AUCtau is not known but only AUCt, `t_auc` specifies time until which AUC_t is calculated to be able to calculate dose
#' @export
dose2auc <- function(dose, CL, V, t_auc = NA) {
  auc_inf <- as.numeric(dose / CL)
  if (!is.na(t_auc)) {
    k <- CL / V
    frac <- 1 - exp(-k * t_auc)
    return(as.numeric(auc_inf * frac))
  } else {
    return(auc_inf)
  }
}
