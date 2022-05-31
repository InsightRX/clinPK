#' Percentile height or weight for age for children
#'
#' This is the underlying function, the exposed functions are pct_weight_for_age() and pct_height_for_age()
#' Based on tables from WHO: http://www.who.int/childgrowth/standards/height_for_age/en/
#'
#' @param age age in years
#' @param sex either `male` or `female`
#' @param value height in kg. Optional, if specified, will calculate closest percentile and return in list as `percentile`
#' @param variable weight or height?
#' @param ... parameters passed to `read_who_table()`
#' @keywords internal
pct_for_age_generic <- function(age = NULL, value = NULL, sex = NULL, variable="weight", ...) {
  if (is.null(age) || is.null(sex)) {
    stop("Age and sex are required!")
  }
  if (variable == "height" & age > 19) {
    message("Sorry, height data currently only available for age <= 19 years.")
    return(NULL)
  }
  if (variable == "weight" & age > 10) {
    message("Sorry, currently only available for age <= 10 years.")
    return(NULL)
  }
  
  if (variable == "height") {
    type = ifelse(age >= 5.1, "hfa", "lhfa")
  } else if (variable == "bmi") {
    type = ifelse(age >= 5.1, "bmi", "bfa")
  } else {
    type <- "wfa"
  }
  
  dat <- read_who_table(sex=sex, age=age, type=type)
  tmp <- dat[which.min(abs(age - dat$age)),-(1:4)]
  pct <- as.list(tmp)
  if(!is.null(value)) {
    p <- c()
    for(i in seq(names(pct))) {
      p <- c(p, as.num(gsub("P", "", names(pct)[i])))
    }
    p[1] <- p[1]/10 # 0.1
    p[length(p)] <- p[length(p)]/10 # 99.9
    p_txt <- paste0("pct_", p)
    if(value >= max(tmp)) {
      message(paste0("Specified ", variable," >= 99.9th percentile!"))
      pct <- list(percentile = 99.9)
    }
    if(value <= min(tmp)) {
      message(paste0("Specified ", variable, " <= 0.1th percentile!"))
      pct <- list(percentile = 0.1)
    }
    if(is.null(pct$percentile)) {
      data <- data.frame(
        x = c(
          as.num(tmp[value <= as.num(tmp)][1]),
          tail(as.num(tmp[value > as.num(tmp)]),1)
        ),
        y = c(
          p[value <= as.num(tmp)][1],
          tail(p[value > as.num(tmp)],1)
        )
      )
      # linearly scale between two values
      fit <- lm(y~x, data)
      par <- coef(fit)
      pct <- list(percentile = round(as.num(par[1] + par[2]*value),1))
    }
  }
  return(pct)
}
