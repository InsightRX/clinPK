#' Calculate terminal half-life for 1-compartment model
#'
#' @param CL clearance
#' @param V volume of central compartment
#'
#' @examples
#' pk_1cmt_t12(CL = 5, V = 50)
#'
#' @export
pk_1cmt_t12 <- function(
  CL = 3,
  V = 30
) {
  ## conversions, if necessary
  if(inherits(CL, "list") && !is.null(CL$value)) { CL <- CL$value }
  if(inherits(V, "list")  && !is.null(V$value)) { V <- V$value }
  kel <- CL / V
  t12 <- log(2) / kel
  return(t12)
}
