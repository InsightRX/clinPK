#' Calculate eGFR based on Cystatin C measurements
#'
#' @param method eGFR estimation method, choose from `grubb`, `larsson`
#' @param cystatin serum cystatin concentration (mg/L)
#' @param cystatin_unit, only `mg/L` available
#' @param unit_out eGFR output unit, choose from `ml/min`, `ml/hr`, `l/min`, `l/hr`
#' @export
calc_egfr_cystatin <- function (
  cystatin = NULL,
  cystatin_unit = "mg/L",
  method = "grubb",
  unit_out = "mL/min"
) {
  available_methods <- c(
    "grubb", "larsson")
  available_units <- c(
    "ml/min", "ml/hr", "l/min", "l/hr"
  )
  method <- gsub("-", "_", tolower(method))
  if(!method %in% available_methods) {
    stop(paste0("Sorry, eGFR calculation method not recognized! Please choose from: ", paste0(available_methods, collapse=" ")))
  }
  if(!tolower(unit_out) %in% available_units) {
    stop(paste0("Sorry, output unit not recognized! Please choose from: ", paste0(available_units, collapse=" ")))
  }
  crcl <- NULL
  unit <- cystatin_unit
  if(method == "grubb") {
    crcl <- 83.93 * cystatin^(-1.676)
  }
  if(method == "larsson") {
    crcl <- 77.239 * cystatin^(-1.2623)
  }
  if (length(grep("^l/min", tolower(unit_out))) > 0) {
    crcl <- crcl / 1000
  }
  if (length(grep("^l/hr", tolower(unit_out))) > 0) {
    crcl <- crcl * 60 / 1000
  }
  if (length(grep("^ml/hr", tolower(unit_out))) > 0) {
    crcl <- crcl * 60
  }
  return(list(
    value = crcl,
    unit = unit_out
  ))
}
