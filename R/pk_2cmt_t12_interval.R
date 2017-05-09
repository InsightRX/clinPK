#' Calculate average half-life for 2-compartment model during a specific interval
#'
#' @param CL clearance
#' @param V volume of central compartment
#' @param Q inter-compartimental clearance
#' @param V2 volume of peripheral compartment
#' @param tau interval (hours)
#' @param t_inf infusion time (hours)
#' @export
pk_2cmt_t12_interval <- function(
  CL = 3,
  V = 30,
  Q = 2,
  V2 = 20,
  tau = 12,
  t_inf = NULL
) {
  ## conversions, if necessary
  if(class(CL) == "list" && !is.null(CL$value)) { CL <- CL$value }
  if(class(V) == "list"  && !is.null(V$value)) { V <- V$value }
  if(class(Q) == "list"  && !is.null(Q$value)) { Q <- Q$value }
  if(class(V2) == "list" && !is.null(V2$value)) { V2 <- V2$value }
  if(!is.null(t_inf)) {
    conc <- pk_2cmt_inf_ss(t=c(t_inf, tau), dose = 1000, tau = tau, t_inf = t_inf, CL=CL, V=V, Q=Q, V2=V2)
  } else {
    conc <- pk_2cmt_bolus_ss(t=c(0, tau), dose = 1000, tau = tau, CL=CL, V=V, Q=Q, V2=V2)
  }
  calc_t12(conc$t[1], conc$t[2], conc$dv[1], conc$dv[2])
}
