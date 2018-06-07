#' Convert dose to expected AUCinf or AUCt for 1 compartment linear PK model
#'
#' @param dose dose amount
#' @param CL Clearance
#' @param V Volume of distribution
#' @param t_auc if AUC_t is desired, `t_auc` specifies time until which AUC_t is calculated
#' @examples
#' dose2auc(dose = 1000, CL = 5, V = 50)
#' dose2auc(dose = 1000, CL = 5, V = 50, t_auc = c(12, 24, 48, 72))
#' @export
dose2auc <- function(dose, CL, V, t_auc = NULL) {
  auc_inf <- as.numeric(dose / CL)
  if (!is.null(t_auc)) {
    k <- CL / V
    frac <- 1 - exp(-k * t_auc)
    return(as.numeric(auc_inf * frac))
  } else {
    return(auc_inf)
  }
}
