#' CDC Growth Charts
#' 
#' Data used to produce the United States Growth Charts smoothed percentile
#' curves for infants and older children.
#' 
#' @details
#' These data sets contain the L (power in the Box-Cox transformation), M
#' (median), and S (generalized coefficient of variation) parameters needed to
#' generate exact percentiles and z-scores for seven different growth charts,
#' along with the 3rd, 5th, 10th, 25th, 50th, 75th, 90th, 95th, and 97th
#' percentile values by sex (1 = male; 2 = female) and single month of age
#' (listed at the half-month point for the entire month).
#' 
#' @source 
#' National Center for Health Statistics. (n.d.). CDC Growth Charts Data Files.
#' <https://www.cdc.gov/growthcharts/cdc-growth-charts.htm>
#' @seealso Functions to calculate growth metrics: [pct_weight_for_age_v],
#'   [pct_height_for_age_v], [pct_bmi_for_age_v], [pct_weight_for_height_v]
#'   
#' LMS growth chart equations: [lms]
#' @name growth-charts
#' @aliases weight_for_age, height_for_age, bmi_for_age_children,
#'   weight_for_height_infants, weight_for_height_children
NULL

#' @rdname growth-charts
#' @format ## `weight_for_age`
#' An object of class `data.frame` with `r nrow(weight_for_age)` rows
#' and `r ncol(weight_for_age)` columns.
"weight_for_age"

#' @rdname growth-charts
#' @format ## `height_for_age`
#' An object of class `data.frame` with `r nrow(height_for_age)` rows
#' and `r ncol(height_for_age)` columns.
"height_for_age"

#' @rdname growth-charts
#' @format ## `bmi_for_age_children`
#' An object of class `data.frame` with `r nrow(bmi_for_age_children)` rows
#' and `r ncol(bmi_for_age_children)` columns.
"bmi_for_age_children"

#' @rdname growth-charts
#' @format ## `weight_for_height_infants`
#' An object of class `data.frame` with `r nrow(weight_for_height_infants)` rows
#' and `r ncol(weight_for_height_infants)` columns.
"weight_for_height_infants"

#' @rdname growth-charts
#' @format ## `weight_for_height_children`
#' An object of class `data.frame` with `r nrow(weight_for_height_children)` rows
#' and `r ncol(weight_for_height_children)` columns.
"weight_for_height_children"
