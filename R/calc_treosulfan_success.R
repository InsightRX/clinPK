#' Calculate probability of therapeutic success for treosulfan
#' 
#' Calculate probability of therapeutic success for treosulfan as a function of
#' cumulative AUC. This model was based on a data set of children receiving
#' treosulfan once daily for 3 days and may not correspond to other dosing
#' intervals or patient populations.
#' 
#' @note
#' The parameter estimates used in this function match Figure 3a in the cited
#' paper, but differ slightly from the values provided in Table 2, which were
#' rounded. The decimal values used here were solved for using results cited in
#' the paper, and are close but not an exact match. 
#'
#' @param cumulative_auc Cumulative AUC mg hour/L.
#' 
#' @references \href{https://doi.org/10.1002/cpt.1715}{
#' Chiesa et al., Clinical Pharmacology and Therapeutics (2020)}
#'
#' @returns Probability of therapeutic success for treosulfan.
#' @export
#'
#' @examples
#' calc_treosulfan_success(c(3863, 4800, 4829, 6037))
#' 
#' curve(
#'   calc_treosulfan_success,
#'   from = 2000, 
#'   to = 15000, 
#'   log = "x", 
#'   ylim = c(0, 1),
#'   xlab = "Cumulative AUC",
#'   ylab = "P(Success)"
#' )
calc_treosulfan_success <- function(cumulative_auc) {
  b0 <- -138
  b1 <- 32.66303
  b2 <- -1.925343
  log_auc <- log(cumulative_auc)
  x <- b0 + b1*log_auc + b2*log_auc^2
  1 - exp(-exp(x))
}
