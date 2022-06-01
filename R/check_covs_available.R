#' Checks whether required covariates for eGFR calculations are present
#'
#' @description returns true if all patient covs specified in required covs are non-null, non-NA and not a 0-character string. See `is.nil` for missing data types checked. Returns TRUE if no covariates are required.
#' @param cov_reqs vector of covariates required for calculating derived covariatiate
#' @param patient_covs named list of covariates
#' @param verbose stop and describe missing covariate(s)?
#' @param fail invoke `stop()` if not all covariates available?
#' @examples
#' check_covs_available(
#'   egfr_cov_reqs('cockcroft_gault_ideal')[[1]],
#'   list(creat = 1, weight = 100, height = 160, sex = 'female', age = 90))
#' @export
check_covs_available <- function(
  cov_reqs = NULL,
  patient_covs = NULL,
  verbose = TRUE,
  fail = TRUE
  ) {

  if (is.null(patient_covs)){
    return(FALSE)
  }

  if (is.null(cov_reqs) | length(cov_reqs) == 0){
    return(TRUE)
  }

  covs_missing <- c()

  for (cov in cov_reqs){
    if (is.nil(patient_covs[[cov]])){
      covs_missing <- c(covs_missing, cov)
    }
  }

  if (length(covs_missing) == 0) {
    return(TRUE)
  } else if (verbose && fail) {
    stop(paste0('Sorry, missing covariates: ', paste0(covs_missing, collapse = ', ')))
  } else {
    return(FALSE)
  }

}
