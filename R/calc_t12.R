#' Calculate half-life based on two points
#'
#' based on two sampling points (in same interval)
#'
#' @param t1 first sampling timepoint
#' @param t2 second sampling timepoint
#' @param y1 first sample value
#' @param y2 second sample value
#' @examples
#' calc_t12(3, 24, 30, 10)
#' @export
calc_t12 <- function(t1, t2, y1, y2) {
  log(2) / (log(y1)-log(y2)) * (t2-t1)
}
