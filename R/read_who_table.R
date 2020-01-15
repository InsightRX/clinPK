#' Internal function to read WHO growth tables from package or download from WHO
#'
#' @param sex, either `male` or `female`
#' @param age age in years
#' @param type table type, choose from `wfa` (weight for age), `lhfa` (length for age)
#' @param who_url base URL for WHO growth tables
#' @param download download current tables from WHO?
#' @export
read_who_table <- function(
  sex = NULL,
  age = NULL,
  type = "wfa",
  who_url = "http://www.who.int/entity/childgrowth/standards",
  download = FALSE) {
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
    if(!download) {
      # use tables supplied with package (also from WHO)
      dat <- data.frame(read.table(file=paste0(system.file(package='clinPK'),'/', who_file), 
                                   sep = "\t", header = TRUE))
    } else {
      cat("Downloading data from WHO...")
      con <- curl::curl(paste0(who_url, "/", who_file))
      open(con)
      tmp <- readLines(con)
      close(con)
      cat("done.")
      dat <- c()
      cnam <- strsplit(tmp[1], "\t")[[1]]
      tmp <- tmp[-1]
      for(i in seq(tmp)) {
        dat <- rbind(dat, as.num(unlist(strsplit(tmp[i], "\t"))))
      }
      dat <- data.frame(dat)
      colnames(dat) <- cnam
    }
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
