#' Convert flow (e.g. clearance) from / to units
#'
#' @param value dose
#' @param from from dose unit
#' @param to from dose unit
#' @param weight for allowing per kg conversion
convert_flow_unit <- function(
  value = NULL,
  from = "l",
  to = "ml",
  weight = NULL) {
  
  from <- irxtools::str_replace_all(tolower(from), "/", "_")
  to <- irxtools::str_replace_all(tolower(to), "/", "_")
  
  find_factor <- function(full_unit, units = NULL, prefix = "^") {
    units[[names(units)[unlist(lapply(names(units), function(x) { length(grep(paste0(prefix, x), full_unit, value=F))>0 }))]]]
  }
  
  ## catch volume units
  volume_units <- list(
    "ml" = 1/1000,
    "dl" = 1/10,
    "l" = 1)
  time_units <- list(
    "min" = 1/60,
    "hr" = 1,
    "day" = 24)
  
  from_volume_factor <- find_factor(from, units = volume_units, "^")
  to_volume_factor <- find_factor(to, units = volume_units, "^")
  
  from_time_factor <- 1/find_factor(from, units = time_units, "_")
  to_time_factor <- 1/find_factor(to, units = time_units, "_")
  
  from_weight <- length(grep("_kg", from, value=F))>0
  to_weight <- length(grep("_kg", to, value = F))>0
  if((from_weight || to_weight) && insightrxr:::is.nil(weight)) {
    stop("Weight required for weight-based conversion of flow rates.")
  }
  
  from_weight_factor <- ifelse(from_weight, 1/weight, 1)
  to_weight_factor <- ifelse(to_weight, 1/weight, 1)
  
  (value * from_volume_factor * from_weight_factor * from_time_factor) / (to_volume_factor * to_time_factor * to_weight_factor)
  
}