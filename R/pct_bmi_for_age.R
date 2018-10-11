#' Percentile BMI for age for children
#'
#' Based on tables from WHO: http://www.who.int/growthref/who2007_bmi_for_age/en/
#'
#' @param age age in years
#' @param sex either `male` or `female`
#' @param height height
#' @param bmi bmi Optional, if specified, will calculate closest percentile and return in list as `percentile`
#' @param return_median just return the median expected value
#' @param ... parameters passed to `read_who_table()`
#' @examples
#' pct_bmi_for_age(age = 8, sex = "male")
#' pct_bmi_for_age(age = 8, bmi = 15, sex = "male")
#' @export
pct_bmi_for_age <- function(age = NULL, bmi = NULL, sex = NULL, height = NULL, return_median = FALSE, ...) {
  if(is.null(age)) {
    stop("Age required.")
  }
  if(length(age) == 1) {
    pct <- pct_for_age_generic(age = age, value = bmi, sex = sex, variable = "bmi", height = height, ...)
  } else {
    tmp <- lapply(age, pct_bmi_for_age, sex=sex)
    pct <- data.frame(cbind("age" = age, matrix(unlist(tmp), nrow=length(age))))
    colnames(pct)[-1] <- names(tmp[[1]])
  }
  if(return_median) {
    return(pct$P50)
  } else {
    return(pct)
  }
  return(pct)
}
