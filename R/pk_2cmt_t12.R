#' Calculate half-life(s) for 2-compartment model
#'
#' @param CL clearance
#' @param V volume of central compartment
#' @param Q inter-compartimental clearance
#' @param V2 volume of peripheral compartment
#' @param phase `alpha`, `beta` (default) or `both` to indicate initial (distribution) or terminal (elimination) phase.
#' @export
pk_2cmt_t12 <- function(
  CL = 3,
  V = 30,
  Q = 2,
  V2 = 20,
  phase = "both"
) {
  ## conversions, if necessary
  if(class(CL) == "list" && !is.null(CL$value)) { CL <- CL$value }
  if(class(V) == "list"  && !is.null(V$value)) { V <- V$value }
  if(class(Q) == "list"  && !is.null(Q$value)) { Q <- Q$value }
  if(class(V2) == "list" && !is.null(V2$value)) { V2 <- V2$value }
  kel <- CL / V
  k12 <- Q / V
  k21 <- Q / V2
  beta <- ((1/2) * ((k12 + k21 + kel) - sqrt((k12 + k21 + kel)^2 - (4*k21*kel))))
  alpha <- k21*kel/beta
  obj <- list(alpha = log(2)/alpha, beta = log(2)/beta)
  if(phase == "both") {
    return(obj)
  } else {
    if(phase == "alpha") {
      t12 <- log(2) / alpha
    } else {
      t12 <- log(2) / beta
    }
    return(t12)
  }
}
