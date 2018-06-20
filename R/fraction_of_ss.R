#' Calculate fraction of steady state at particular time after start of dosing
#'
#' @param kel drug elimination rate
#' @param halflife halflife. Either `kel` or `halflife` is required.
#' @param t time at which to calculate fraction of steady state
#' @param n number of dosing intervals after which to calculate fraction of steady state. Requires `tau` as well, cannot be used together with `t` argument.
#' @param tau dosing interval
#' @examples
#' fraction_of_ss(halflife = 24, t = 72)
#' fraction_of_ss(halflife = 36, n = 3, tau = 24)
#' @export
fraction_of_ss <- function(
  kel = NULL,
  halflife = NULL,
  t = NULL,
  n = NULL,
  tau = NULL
) {
  if(is.null(kel) && is.null(halflife)) stop("Need either elimination rate `kel` or `halflife`")
  if(is.null(kel)) kel <- log(2) / halflife
  if(is.null(t)) {
    if(is.null(n) || is.null(tau)) {
      stop("Either time `t` or number of doses `n` and dosing interval `tau` have to be specified!")
    }
    t <- n * tau
  }
  return(1-exp(-t * kel))
}
