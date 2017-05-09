#' Percentile weight for age for children
#'
#' Based on tables from WHO: http://www.who.int/childgrowth/standards/weight_for_age/en/
#'
#' @param age age in years
#' @param sex either `male` or `female`
#' @param weight weight in kg. Optional, if specified, will calculate closest percentile and return in list as `percentile`
#' @param ... parameters passed to `read_who_table()`
#' @export
pct_weight_for_age <- function(age = NULL, weight = NULL, sex = NULL, ...) {
  if(is.null(age)) {
    stop("Age required.")
  }
  if(length(age) == 1) {
    pct <- pct_for_age_generic(age = age, value = weight, sex = sex, variable = "weight", ...)
  } else {
    if(is.null(weight)) {
      tmp <- lapply(age, pct_weight_for_age, sex = sex)
    } else {
      stop("Sorry, a specific weight value cannot be supplied when age is a vector.")
    }
    pct <- data.frame(cbind("age" = age, matrix(unlist(tmp), nrow=length(age))))
    colnames(pct)[-1] <- names(tmp[[1]])
  }
  return(pct)
}
