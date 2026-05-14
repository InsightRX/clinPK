#' Calculate commonly used "dosing weight" 
#' 
#' Dosing weight is determined based on total (TBW), ideal (IBW), or 
#' adjusted (ABW) body weight in kg.
#' 
#' This is derived using following:
#' - In principle, use IBW
#' - If total body weight (TBW) > 1.2*IBW, then use ABW
#' - If TBW < IBW, use TBW
#' @param weight weight
#' @param height height
#' @param sex sex
#' @param age age
#' @param verbose verbosity (`TRUE` or `FALSE`)
#' @param ... pased to `calc_abw()` function
#' @return Returns a list of the following elements:
#' \item{value}{Dosing weight, in units of kg}
#' \item{unit}{Units of dosing weight (kg)}
#' \item{type}{Type of dosing weight selected, e.g., total body weight, ideal body weight.}
#' @export
#' @examples
#' calc_dosing_weight(weight = 50, height = 170, sex = "female", age = 50)
calc_dosing_weight <- function(weight, height, age, sex, verbose = TRUE, ...) {
  if(is.null(weight) || is.null(height) || is.null(age) || is.null(sex)) {
    stop("Dosing weight calculation requires weight, height, age, and sex.")
  }
  ibw <- calc_ibw(weight = weight, height = height, age = age, sex = sex)
  abw <- calc_abw(weight = weight, ibw = ibw, ...)
  weight_type <- ifelse(
    weight > ibw * 1.2,
    "Adjusted BW",
    ifelse(
      weight < ibw,
      "Total BW",
      "Ideal BW"
    )
  )
  wt_chosen <- ifelse(weight > ibw * 1.2, abw, ifelse(weight < ibw, weight, ibw))
  if (verbose) {
    types <- unique(weight_type)
    if ("Adjusted BW" %in% types) message("Using adjusted body weight.")
    if ("Total BW" %in% types) message("Using total body weight.")
    if ("Ideal BW" %in% types) message("Using ideal body weight.")
  }
  return(list(value = wt_chosen, unit = "kg", type = weight_type))
}
