#' Calvert equation for carboplatin
#' 
#' The Calvert equation calculates a dose expected to bring the patient to the
#' target AUC given their glomerular filtration rate (GFR). The original 
#' equation was developed on a data set of 18 individuals with GFR of 
#' 33-136 ml/min.
#' 
#' @references \href{https://ascopubs.org/doi/abs/10.1200/JCO.1989.7.11.1748}{
#' Calvert et al., Journal of Clinical Oncology (1976)}
#' 
#' @param target_auc target AUC, in mg/ml-min, typically between 2-8 mg/ml-min
#' @param gfr glomerular filtration rate, in ml/min. See also 
#'   `clinPK::calc_egfr`.
#' @param ... arguments passed on to `calc_egfr` if gfr is not supplied
#' @examples
#' calc_carboplatin_calvert(5, 100)
#' calc_carboplatin_calvert(4, 30)
#' calc_carboplatin_calvert(2, sex = "male", age = 50, scr = 1.1, weight = 70)
#' 
#' @export

calc_carboplatin_calvert <- function(target_auc, gfr = NULL, ...) {
  if (is.null(gfr)) gfr <- calc_egfr(..., relative=FALSE)[["value"]]
  target_auc * (1.2 * gfr + 20)
}