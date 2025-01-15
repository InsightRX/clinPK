#' Calculate Cefepime-associated Neurotoxicity
#' 
#' Calculate probability of cefepime-associated neurotoxicity as a function of
#' cefepime plasma trough concentrations.
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
  # The intercept for this model was not reported in the paper, so we contacted
  # the corresponding author, Dr. Babouee-Flury, for assistance. They provided
  # us with the unrounded intercept and slope values, along with anonymized
  # data, which we used to replicate these results. The intercept and slope here
  # are raw coefficients (log odds). Note that model predictions with these
  # coefficients do not match what is reported in Figure 2 of the paper---this
  # is because that curve and the reported values were "produced automatically
  # in ggplot using a geometric smoother, not fit directly". The true
  # predictions are actually closer to the probability of being neurotoxic
  # equalling 0.25 at 13.7mg/L, and 0.50 at 17.8mg/L.
  b0 <- -4.7777798
  b1 <- 0.2684747
  stats::plogis(b0 + b1*trough_concentration)
}
