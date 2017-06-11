#' Calculate the amounts in all compartments in a compartmental PK system
#' based on a given concentration in the central compartment, and assuming
#' steady state.
#'
#' @param conc concentration in central compartment
#' @param parameters for PK model
#' @param n_cmt number of compartments
#' @examples
#' calc_amts_for_conc(conc = 10, parameters = list(CL = 5, V = 50), n_cmt = 1)
#' calc_amts_for_conc(
#'   conc = 10,
#'   parameters = list(CL = 5, V = 50, Q = 20, V2 = 100),
#'   n_cmt = 2)
#' calc_amts_for_conc(
#'   conc = 10,
#'   parameters = list(CL = 5, V = 50, Q = 20, V2 = 100, Q2 = 30, V3 = 200),
#'   n_cmt = 3)
#' @export
calc_amts_for_conc <- function(conc = 10, parameters = NULL, n_cmt = 1) {
  if(!(n_cmt %in% c(1,2,3))) {
    stop("Number of compartments needs to be either 1, 2, or 3.")
  }
  if(n_cmt == 1) {
    if(is.null(parameters$V)) {
      stop("Need parameter V!")
    }
    A <- c(conc * parameters$V)
  }
  if(n_cmt == 2) {
    if(length(unlist(parameters[c("V", "V2")])) != 2) {
      stop("Need parameters V, V2!")
    }
    A <- c(0, 0)
    A[1] <- c(conc * parameters$V)
    # assuming ss: Q/V * A[1] = Q/V2 * A[2]
    # therefore    A[2] = Q/V * A[1] / (Q/V2) = V2/V * A[1]
    A[2] <- (parameters$V2/parameters$V) * A[1]
  }
  if(n_cmt == 3) {
    if(length(unlist(parameters[c("V", "V2", "V3")])) != 3) {
      stop("Need parameters V, V2, V3!")
    }
    A <- c(0, 0, 0)
    A[1] <- c(conc * parameters$V)
    A[2] <- (parameters$V2/parameters$V) * A[1]
    A[3] <- (parameters$V3/parameters$V) * A[1]
  }
  return(A)
}
