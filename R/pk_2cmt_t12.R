#' Calculate half-life(s) for 2-compartment model
#'
#' @param CL clearance
#' @param V volume of central compartment
#' @param Q inter-compartimental clearance
#' @param V2 volume of peripheral compartment
#' @param phase `alpha`, `beta` (default) or `both` to indicate initial (distribution) or terminal (elimination) phase.
#' @examples
#' pk_2cmt_t12(CL = 5, V = 50, Q = 20, V2 = 200)
#' @export
pk_2cmt_t12 <- function(
  CL = 3,
  V = 30,
  Q = 2,
  V2 = 20,
  phase = c("both", "alpha", "beta")
) {
  phase <- match.arg(phase)
  ## conversions, if necessary
  if(inherits(CL, "list") && !is.null(CL$value)) { CL <- CL$value }
  if(inherits(V, "list")  && !is.null(V$value)) { V <- V$value }
  if(inherits(Q, "list")  && !is.null(Q$value)) { Q <- Q$value }
  if(inherits(V2, "list") && !is.null(V2$value)) { V2 <- V2$value }
  kel <- CL / V
  k12 <- Q / V
  k21 <- Q / V2
  beta <- ((1/2) * ((k12 + k21 + kel) - sqrt((k12 + k21 + kel)^2 - (4*k21*kel))))
  alpha <- k21*kel/beta
  
  switch(
    phase,
    "both" = list(alpha = log(2)/alpha, beta = log(2)/beta),
    "alpha" = log(2) / alpha,
    "beta" = log(2) / beta
  )
}
