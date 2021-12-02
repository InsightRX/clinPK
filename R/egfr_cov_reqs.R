#' Returns parameters needed to calculate eGFR according to the method specified.
#' @description returns a named list, with the name being the eGFR method after being checked for certain typos or misspecifications, and the values being the required covariates.
#' @param method egfr calculation method
#' @param relative if egfr calculations should be relative or not
#' @examples 
#' egfr_cov_reqs('schwartz_revised')
#' @export
egfr_cov_reqs <- function(method, relative = NULL){
  # Format input
  if (is.nil(method)) {
    stop(paste('egfr method unspecified'))
  }
  method <- tolower(method)
  method <- gsub("-", "_", method)
  method <- gsub("cockroft", "cockcroft", method) # legacy support for typo
  
  # Check method is supported
  available_methods <- c(
    "cockcroft_gault", "cockcroft_gault_ideal", "cockcroft_gault_adjusted",
    "cockcroft_gault_adaptive", "cockcroft_gault_sci",
    "malmo_lund_revised", "malmo_lund_rev", "lund_malmo_revised", "lund_malmo_rev",
    "mdrd", "mdrd_ignore_race", "mdrd_original", "mdrd_original_ignore_race",
    "ckd_epi", "ckd_epi_ignore_race", "ckd_epi_as_2021", 
    "schwartz", "schwartz_revised", "bedside_schwartz", 
    "jelliffe", "jelliffe_unstable", "wright"
  )
  if(!(method %in% available_methods)) {
    stop(paste0("Sorry, eGFR calculation method not recognized! Please choose from: ", 
                paste0(available_methods, collapse=", ")))
  }
  
  #interpret needed covariates per method
  if (method %in% c("cockcroft_gault", "jelliffe_unstable", "cockcroft_gault_sci")) {
    covs <- list(c("creat", "age", "weight", "sex"))
    
  } else if (method %in% c("malmo_lund_revised", "malmo_lund_rev", "lund_malmo_revised", "lund_malmo_rev", "mdrd_ignore_race", "mdrd_original_ignore_race", "ckd_epi_ignore_race", "ckd_epi_as_2021")) {
    covs <- list(c("creat", "sex", "age"))
    
  } else if (method %in% c("schwartz_revised", "bedside_schwartz")) {
    covs <- list(c("creat", "age", "sex", "height"))
    
  } else if (method %in% c("schwartz")) {
    covs <- list(c("creat", "age", "sex", "height", "preterm"))
    
  } else if (method %in% c("mdrd", "mdrd_original", "ckd_epi")) {
    covs <- list(c("creat", "sex", "age", "race"))
    
  } else if (method %in% c("jelliffe", "wright")) {
    covs <- list( c("creat", "sex", "age", "bsa"))
  
  } else if (method %in% c("cockcroft_gault_ideal", "cockcroft_gault_adjusted", "cockcroft_gault_adaptive")) {
    covs <- list(c("creat", "age", "weight", "sex", "height"))
  
  } else {
    stop('required covariates unknown')
  }
  
  # ---- Relative eGFR?
  if (is.nil(relative)) {
    # By default, assume true, since most equations report in units of /1.73m2.
    # Cockcroft-Gault and derived formulae do not report in relative units, but
    # do not require bsa to convert.
    relative <- ifelse(grepl('cockcroft_gault', method), FALSE, TRUE)
  }
  if (!relative & !grepl('cockcroft_gault', method)) {
    covs[[1]] <- unique(c('bsa', covs[[1]]))
  } else if (relative & grepl('cockcroft_gault', method)) {
    covs[[1]] <- unique(c('bsa', covs[[1]]))
  }
  
  names(covs) <- method
  return(covs)
}