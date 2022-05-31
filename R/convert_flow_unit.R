#' Convert flow (e.g. clearance) from / to units
#' 
#' Flow units are expected to be specified as a combination
#' of volume per time units, potentially specified per kg
#' body weight, e.g. "mL/min", or "L/hr/kg".
#' 
#' Accepted volume units are "L", "dL", and "mL".
#' Accepted time units are "min", "hr", and "day". 
#' The only accepted weight unit is "kg".
#' 
#' The function is not case-sensitive.
#' 
#' @param value flow value
#' @param from from flow unit, e.g. `L/hr`. 
#' @param to to flow unit, e.g. `mL/min`
#' @param weight for performing per weight (kg) conversion
#' 
#' @examples 
#' 
#' ## single values
#' convert_flow_unit(60, "L/hr", "ml/min")
#' convert_flow_unit(1, "L/hr/kg", "ml/min", weight = 80)
#' 
#' ## vectorized
#' convert_flow_unit(
#'   c(10, 20, 30), 
#'   from = c("L/hr", "mL/min", "L/hr"), 
#'   to = c("ml/min/kg", "L/hr", "L/hr/kg"), 
#'   weight = c(70, 80, 90))
#'   
#' @export
convert_flow_unit <- function(
  value = NULL,
  from = "l",
  to = "ml",
  weight = NULL) {

  ## Input checks:
  if(is.null(from)) {
    stop("`from` argument not specified.")
  }
  if(is.null(to)) {
    stop("`to` argument not specified.")
  }
  if(length(from) != 1 && length(from) != length(value)) {
    stop("`from` argument should be either a single value or a vector of the same length as the `value` argument.")
  }
  if(length(to) != 1 && length(to) != length(value)) {
    stop("`to` argument should be either a single value or a vector of the same length as the `value` argument.")
  }

  ## Clean up the from/to units:
  from <- gsub("\\/", "_", tolower(from))
  to <- gsub("\\/", "_", tolower(to))

  ## Definition of the units:  
  volume_units <- list(
    "ml" = 1/1000,
    "dl" = 1/10,
    "l" = 1)
  time_units <- list(
    "min" = 1/60,
    "hr" = 1,
    "day" = 24)
  
  ## Calculate volume conversion factors
  tryCatch({ 
    from_volume_factor <- as.numeric(vapply(from, FUN = function(x) {
      find_factor(x, units = volume_units, "^") # volume is always at the start, hence ^
    }, 1))
  }, error = function(e) { stop("Volume unit not recognized in `from` argument.") })
  
  tryCatch({ 
    to_volume_factor <- as.numeric(vapply(to, FUN = function(x) {
      find_factor(x, units = volume_units, "^") # volume is always at the start, hence ^
    }, 1))
  }, error = function(e) { stop("Volume unit not recognized in `to` argument.") })

  ## Calculate per time conversion factors
  tryCatch({ 
    from_time_factor <- 1/as.numeric(vapply(from, FUN = function(x) {
      find_factor(x, units = time_units, "_") # time is never at the start, always after "/" or "_"
    }, 1))
  }, error = function(e) { stop("Time unit not recognized in `from` argument.") })
  
  tryCatch({ 
    to_time_factor <- 1/as.numeric(vapply(to, FUN = function(x) {
      find_factor(x, units = time_units, "_") # time is never at the start, always after "/" or "_"
    }, 1))
  }, error = function(e) { stop("Time unit not recognized in `to` argument.") })
  
  ## Calculate weight conversion factors
  from_weight <- as.logical(vapply(from, function(x) { length(grep("_kg", x, value=F))>0 }, TRUE))
  to_weight <- as.logical(vapply(to, function(x) { length(grep("_kg", x, value=F))>0 }, TRUE))
  if((any(from_weight) || any(to_weight))) {
    if(is.null(weight)) stop("Weight required for weight-based conversion of flow rates.")
    if(length(weight) != 1 && length(weight) != length(value)) {
      stop("`weight` argument should be either a single value or a vector of the same length as the `value` argument.")
    }
  }
  
  from_weight_factor <- ifelse(from_weight, weight, 1)
  to_weight_factor <- ifelse(to_weight, weight, 1)

  ## Combine factors and return  
  value * 
    (from_volume_factor * from_weight_factor * from_time_factor) /
    (to_volume_factor * to_time_factor * to_weight_factor)
  
}

#' Helper function to grab the conversion factor from an input unit and given list
#' 
#' @param full_unit full unit, e.g. "mL/min/kg"
#' @param units unit specification list, e.g. `list("ml" = 1/1000, "dl" = 1/10, "l" = 1)`
#' @param prefix prefix used in matching units, e.g. "^" only matches at start of string while "_" matches units specified as "/"
#' @keywords internal
find_factor <- function(full_unit, units = NULL, prefix = "^") {
  unlist(units[vapply(names(units), function(x) { grepl(paste0(prefix, x), full_unit) }, FUN.VALUE = logical(1))], use.names = FALSE)  
}
