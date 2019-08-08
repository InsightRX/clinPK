#' Returns parameters needed to calculate eGFR according to the method specified.
#' @param method egfr calculation method
#' @examples 
#' egfr_cov_reqs('schwartz_revised')
#' @export
egfr_cov_reqs <- function(method){
  # Format input
  method <- tolower(method)
  method <- gsub("-", "_", method)
  method <- gsub("cockroft", "cockcroft", method) # legacy support for typo
  
  # Check method is supported
  available_methods <- c(
    "cockcroft_gault", "cockcroft_gault_ideal", "cockcroft_gault_adjusted",
    "cockcroft_gault_adaptive", "cockcroft_gault_sci",
    "malmo_lund_revised", "malmo_lund_rev", "lund_malmo_revised", "lund_malmo_rev",
    "mdrd", "ckd_epi", "schwartz", "schwartz_revised", "bedside_schwartz", "jelliffe", "jelliffe_unstable",
    "wright")
  if(!method %in% available_methods) {
    stop(paste0("Sorry, eGFR calculation method not recognized! Please choose from: ", 
                paste0(available_methods, collapse=", ")))
  }
  
  #interpret needed covariates per method
  if (method %in% c("cockcroft_gault", "jelliffe_unstable", "cockcroft_gault_sci")) {
    return(c("creat", "age", "weight", "sex"))
  }
  if (method %in% c("malmo_lund_revised", "malmo_lund_rev", "lund_malmo_revised", "lund_malmo_rev")) {
    return(c("creat", "sex", "age"))
  }
  if (method %in% c("schwartz_revised", "bedside_schwartz")) {
    return(c("creat", "age", "sex", "height"))
  }
  if (method %in% c("schwartz")) {
    return(c("creat", "age", "sex", "height", "preterm"))
    
  }
  if (method %in% c("mdrd", "ckd_epi")){
    return(c("creat", "sex", "age", "race"))
  }
  if (method %in% c("jelliffe", "wright")) {
    return(c("creat", "sex", "age", "bsa"))
  }
  if (method %in% c("cockcroft_gault_ideal", "cockcroft_gault_adjusted", "cockcroft_gault_adaptive")) {
    return(c("creat", "age", "weight", "sex", "height"))
  }
  stop('required covariates unknown')
}