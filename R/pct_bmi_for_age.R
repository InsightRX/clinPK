#' Percentile BMI for age for children
#'
#' Based on tables from WHO: http://www.who.int/growthref/who2007_bmi_for_age/en/
#'
#' @param age age in years
#' @param sex either `male` or `female`
#' @param height height
#' @param bmi bmi Optional, if specified, will calculate closest percentile and return in list as `percentile`
#' @param ... parameters passed to `read_who_table()`
#' @export
pct_bmi_for_age <- function(age = NULL, bmi = NULL, sex = NULL, height = NULL, ...) {
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
  return(pct)
}
