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
#' calc_cefepime_neurotoxicity(trough_concentration = c(12, 16))
#' @export
calc_cefepime_neurotoxicity <- function(trough_concentration) {
  # This calculation uses the single predictor cefepime plasma trough
  # concentration model in Table 2. The coefficient for cefepime plasma trough
  # concentration is reported as an odds ratio, so we'll first convert it back
  # to log odds using the inverse transformation.
  b1 <- log(1.31)
  
  # The intercept is not reported in the paper, so we need to solve for it using
  # some of the information from Fig. 2. Boschung-Pasquier et al. report that the
  # probability of being neurotoxic is 0.25 at 12 mg/L, and 0.5 at 16 mg/L. Since
  # these values are rounded, we can solve the intercept for both probability
  # values, then take their average as the intercept to use for calculations.
  b0.25 <- log(.25/.75) - b1*12
  b0.50 <- log(.5/.5) - b1*16
  b0 <- mean(c(b0.25, b0.50))
  
  stats::plogis(b0 + b1*trough_concentration)
}
