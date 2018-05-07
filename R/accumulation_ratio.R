#' Calculate accumulation ratio
#' This is the ratio of drug concentration or AUC at steady state over concentrations after single dose
#'
#' @param kel drug elimination rate
#' @param halflife halflife. Either `kel` or `halflife` is required.
#' @param tau dosing interval
#' @examples
#' accumulation_ratio(halflife = 24, tau = 24)
#' accumulation_ratio(kel = 0.08, tau = 12)
#' @export
accumulation_ratio <- function(
  kel = NULL,
  halflife = NULL,
  tau = 24) {
  if(is.null(kel) && is.null(halflife)) stop("Need either elimination rate `kel` or `halflife`")
  if(is.null(kel)) kel <- log(2) / halflife
  return(
    1/(1-exp(-kel*tau))
  )
}
