#' Returns parameters needed to calculate eGFR according to the method specified.
#' @param cov_reqs vector of covariates required for calculating derived covariatiate
#' @param patient_covs named list of covariates
#' @param verbose stop and describe missing covariate(s)?
#' @examples 
#' check_covs_available(egfr_cov_reqs('cockcroft_gault_ideal'), list(creat = 1, weight = 100, height = 160, sex = 'female', age = 90))
#' check_covs_available(egfr_cov_reqs('schwartz'), list(creat = c(0.2, 0.4), weight = 25, height = 80, sex = 'male', age = NULL))
#' @export
check_covs_available <- function(
  cov_reqs = NULL,
  patient_covs = NULL,
  verbose = TRUE
  ) {
  
  if(is.null(cov_reqs) | is.null(patient_covs)){
    return(FALSE)
  }
  
  covs_missing <- c()
  
  for (cov in cov_reqs){
    if (is.nil(patient_covs[[cov]])){
      covs_missing <- c(covs_missing, cov)
    }
  }
  
  if (length(covs_missing) == 0) {
    return(TRUE)
  } else if (verbose) {
    stop(paste0('Sorry, missing covariates: ', paste0(covs_missing, collapse = ', ')))
  } else {
    return(FALSE)
  }
  
}