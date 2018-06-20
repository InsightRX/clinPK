#' Convert concentration to molar
#'
#' @param conc concentration in e.g. g/L
#' @param unit_conc, one of `g/l`, `mg/l`, `microg/l`, `mcg/l", `ng/l`, `mg/ml`, `microg/ml`, `mcg/ml`, `ng/ml`
#' @param mol_weight concentration in g/mol
#' @param unit_mol one of `mol/L`, `mmol/mL`, `mmol/L`
#' @examples
#' conc2mol(100, unit_conc = "g/l", mol_weight = 180.15588)
#' @export
conc2mol <- function(
  conc = NULL,
  unit_conc = NULL,
  mol_weight = NULL,
  unit_mol = NULL) {
  if(is.null(mol_weight)) {
    stop("Molecular weight not specified.")
  }
  units_conc <- c("g/l", "mg/l", "microg/l", "mcg/l", "ng/l",
             "mg/ml", "microg/ml", "mcg/ml", "ng/ml")
  if(is.null(unit_conc)) {
    message("Unit not specified, assuming mg/L.")
    unit_conc <- "mg/l"
  }
  unit_conc <- tolower(unit_conc)
  if(is.null(unit_mol)) {
    message("Molar unit not specified, assuming mol/L.")
    unit_mol <- "mol/L"
  }
  if(tolower(unit_conc) %in% units_conc) {
    fact <- 1 #  if(unit_conc == "g/l" || unit_conc == "mg/ml") {
    if(unit_conc == "mg/l" || unit_conc == "microg/ml" || unit_conc == "mcg/ml") {
      fact <- 1e3
    }
    if(unit_conc == "microg/l" || unit_conc == "mcg/l" || unit_conc == "ng/ml") {
      fact <- 1e6
    }
    if(unit_conc == "ng/l" || unit_conc == "pcg/ml") {
      fact <- 1e9
    }
    mol <- (conc/fact)/mol_weight
    units_mol <- c("mol/l", "mmol/l", "mmol/ml")
    if(tolower(unit_mol) %in% units_mol) {
      if(tolower(unit_mol) == "mol/l" || tolower(unit_mol) == "mmol/ml") {
        return(list(value = mol, unit = unit_mol))
      }
      if(tolower(unit_mol) == "mmol/l") {
        return(list(value = mol*1e3, unit = unit_mol))
      }
    } else {
      stop(paste0("Unknown unit for output, choose one of: ", paste(units_mol, collapse=" ")))
    }
  } else {
    stop(paste0("Unknown unit for concentration, choose one of: ", paste(units_conc, collapse=" ")))
  }
}
