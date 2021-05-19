#' Time to steady state
#' In either time units or number of doses
#'
#' @param kel drug elimination rate
#' @param halflife halflife. Either `kel` or `halflife` is required.
#' @param ss level considered "steady state", e.g. `0.9` is 90\% of true steady state.
#' @param in_doses return the number of doses instead of time unit? Default `FALSE`. Requires `tau` as well.
#' @param tau dosing interval
#' @examples
#' time_to_ss(halflife = 12, ss = 0.9)
#' time_to_ss(halflife = 16, ss = 0.95, in_doses = TRUE, tau = 12)
#' @export
time_to_ss <- function(
  kel = NULL,
  halflife = NULL,
  ss = 0.9,
  in_doses = FALSE,
  tau = NULL) {
  if(is.null(kel) && is.null(halflife)) stop("Need either elimination rate `kel` or `halflife`")
  if (ss >= 1) stop("`ss` must be less than 1")
  if(is.null(kel)) kel <- log(2) / halflife
  t2ss <- -log(1 - ss)/kel
  if(in_doses) {
    if(is.null(tau)) {
      stop("Need dosing interval `tau` to calculate number of doses to reach steady state.")
    } else {
      return(t2ss/tau)
    }
  } else {
    return(t2ss)
  }
}
