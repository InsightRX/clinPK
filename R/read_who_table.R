#' Read WHO growth tables
#'
#' Provides a data frame of the WHO growth table for a given age, sex, and type
#' of measurement.
#'
#' This function uses files included in `system.file(package = "clinPK")`.
#' Previously this function also gave the option to download the tables from
#' WHO, but the original URL ("http://www.who.int/entity/childgrowth/standards")
#' no longer exists as of 2021-05-19.
#'
#' @param sex, either `male` or `female`
#' @param age age in years
#' @param type table type, choose from `wfa` (weight for age), `lhfa` (length for age)
#' @export
#' @md
read_who_table <- function(
  sex = NULL,
  age = NULL,
  type = "wfa"
) {
  if(is.null(age)) {
    stop("Age required!")
  }
  if(type %in% c("wfa", "lhfa", "hfa", "wfl", "bmi", "bfa")) {
    
    str_sex <- ifelse(tolower(sex) == "female", "girls", "boys")

    if(age < 5.1) {
      unit <- 365 # table in days
      postfix <- 'p_exp'
    } else {
      unit <- 12 # table in months
      postfix <- 'perc_WHO2007_exp'
      rm_sd <- TRUE
    }
    
    who_file <- paste0(type, '_', str_sex, '_', postfix,'.txt')
    # use tables supplied with package (from WHO)
    dat <- data.frame(
      read.table(
        file = paste0(system.file(package = 'clinPK'), '/', who_file),
        sep = "\t",
        header = TRUE
      )
    )
    dat[,1] <- dat[,1]/unit # convert to years
    colnames(dat)[1] <- "age"
    if("StDev" %in% names(dat)) {
      dat <- dat[,-match("StDev", names(dat))]
    }
    return(dat)
  } else {
    stop("Sorry, type of WHO table unknown.")
  }
}
