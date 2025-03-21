#' LMS growth chart equations
#' 
#' LMS equations to calculate z-scores, percentiles, and other metrics for
#' infants and children.
#'
#' @param l The power in the Box-Cox transformation (L).
#' @param m The median (M).
#' @param s The generalized coefficient of variation (S)
#' @param z,p The z-score (Z) or percentile to return the value of a given
#'   physical measurement (X) at. Only one of `z` or `p` can be provided, not
#'   both.
#' @param x A given physical measurement (X) to return the corresponding z-score
#'   (Z) or percentile for.
#' @param value A character string determining whether to return the
#'   corresponding z-score (Z) or percentile.
#' 
#' @source 
#' National Center for Health Statistics. (n.d.). CDC Growth Charts Data Files.
#' <https://www.cdc.gov/growthcharts/cdc-growth-charts.htm>
#' @seealso
#' CDC Growth Charts data with LMS parameters: [weight_for_age],
#' [height_for_age], [bmi_for_age_children], [weight_for_height_infants],
#' [weight_for_height_children]
#' 
#' Functions to calculate growth metrics: [pct_weight_for_age_v], [pct_height_for_age_v],
#' [pct_bmi_for_age_v], [pct_weight_for_height_v]
#' @returns `lms_for_x()` returns the value of a given physical measurement (X)
#'   at a particular z-score (Z) or percentile. `lms_for_z()` returns the
#'   z-score (Z) or corresponding percentile for a given measurement (X).
#' @name lms
#' @aliases lms_for_x, lms_for_z
#' 
#' @examples
#' lms_for_x(l = -0.1600954, m = 9.476500305, s = 0.11218624, z = -1.645)
#' 
#' lms_for_z(
#'   l = -0.1600954, m = 9.476500305, s = 0.11218624, x = 9.7, value = "p"
#' )
NULL

#' @rdname lms
#' @export
lms_for_x <- function(l, m, s, z = NULL, p = NULL) {
  if (!is.null(z) & !is.null(p)) {
    stop("Only one of `z` or `p` can be provided, not both.")
  } else if (!is.null(p)) {
    z <- qnorm(p)
  }
  x <- ifelse(
    l == 0,
    m * exp(s * z),
    m * (1 + l*s*z)**(1/l)
  )
  x
}

#' @rdname lms
#' @export
lms_for_z <- function(l, m, s, x, value = c("z", "p")) {
  value <- match.arg(value)
  z <- ifelse(
    l == 0,
    log(x/m)/s,
    (((x/m)^l) - 1) / (l*s)
  )
  if (value == "p") z <- pnorm(z) * 100
  z
}
