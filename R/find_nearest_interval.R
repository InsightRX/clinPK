#' Generic function to calculate the interval nearest to a possible dosing interval
#'
#' @param interval dose value
#' @param possible available increments of dose
#' @param type pick either `nearest` absolute interval, or nearest `lower`, or nearest `higher` interval.
#' @examples
#' find_nearest_interval(19.7)
#' find_nearest_interval(19.7, c(6, 8, 12))
#' @export
find_nearest_interval <- function(interval = NULL, possible = c(4, 6, 8, 12, 24, 36, 48), type = "absolute") {
  if(!is.null(interval)) {
    if(type %in% c("absolute", "lower", "higher")) {
      if(type == "lower") {
        poss_tmp <- possible[possible <= interval]
        if(length(poss_tmp) > 0) {
          idx <- abs(interval - poss_tmp)
          return(poss_tmp[order(idx)][1])
        } else {
          type <- "absolute"
          warning("No lower interval found, returning nearest absolute interval.")
        }
      }
      if(type == "higher") {
        poss_tmp <- possible[possible >= interval]
        if(length(poss_tmp) > 0) {
          idx <- abs(interval - poss_tmp)
          return(poss_tmp[order(idx)][1])
        } else {
          type <- "absolute"
          warning("No higher interval found, returning nearest absolute interval.")
        }
      }
      if(type == "absolute") {
        idx <- abs(interval - possible)
        return(possible[order(idx)][1])
      }
    } else {
      stop("Incorrect find type specified.")
    }
  } else {
    stop("No interval specified.")
  }
}
