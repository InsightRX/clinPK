#' Percentile height for age for children
#'
#' Based on tables from WHO: http://www.who.int/childgrowth/standards/height_for_age/en/
#'
#' @param age age in years
#' @param sex either `male` or `female`
#' @param height height in kg. Optional, if specified, will calculate closest percentile and return in list as `percentile`
#' @param return_median just return the median expected value
#' @param ... parameters passed to `read_who_table()`
#' @examples
#' pct_height_for_age(age = 5, sex = "female")
#' pct_height_for_age(age = 5, height = 112, sex = "female")
#' @export
pct_height_for_age <- function(age = NULL, height = NULL, sex = NULL, return_median = FALSE, ...) {
  if(is.null(age)) {
    stop("Age required.")
  }
  if(length(age) == 1) {
    if (return_median) {
      pct <- pct_for_age_generic(age = age, sex = sex, variable = "height", ...)
    } else {
      pct <- pct_for_age_generic(age = age, value = height, sex = sex, variable = "height", ...)
    }
  } else {
    if(is.null(height)) {
      tmp <- lapply(age, pct_height_for_age, sex=sex)
    } else {
      stop("Sorry, a specific height value cannot be supplied when age is a vector.")
    }
    pct <- data.frame(cbind("age" = age, matrix(unlist(tmp), nrow=length(age))))
    colnames(pct)[-1] <- names(tmp[[1]])
  }
  if(return_median) {
    return(pct$P50)
  } else {
    return(pct)
  }
}
