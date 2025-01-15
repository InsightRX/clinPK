#' Calculate Cefepime-associated Neurotoxicity
#' 
#' Calculate probability of cefepime-associated neurotoxicity as a function of
#' cefepime plasma trough concentrations. This model was based on a data set
#' of adult patients receiving thrice-daily cefepime and may not correspond to
#' other dosing intervals or patient populations.
#' 
#' @note
#' The intercept and slope used in this function match Figure 2 in the cited
#' paper, but differ slightly from the values provided in the text. This 
#' interpretation was confirmed via correspondence with the authors.
#' 
#' @param trough_concentration Cefepime plasma trough concentration (mg/L).
#' @references \href{https://doi.org/10.1016/j.cmi.2019.06.028}{
#' Boschung-Pasquier et al., Clinical Microbiology and Infection (2020)}
#' 
#' @return Probability of cefepime-associated neurotoxicity.
#' @examples
#' calc_cefepime_neurotoxicity(trough_concentration = c(13.7, 17.8))
#' @export
calc_cefepime_neurotoxicity <- function(trough_concentration) {
  b0 <- -4.7777798
  b1 <- 0.2684747
  stats::plogis(b0 + b1*trough_concentration)
}
