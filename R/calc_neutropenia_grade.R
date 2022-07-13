#' Calculate neutropenia grade from ANC
#'
#' Assigns neutropenia grade based on the National Cancer Institute system. Note
#' that while this system assigns a grade of 1 to an ANC between 1500-2000, the
#' term neutropenia is usually reserved for a grade of 2 or higher (an ANC of
#' <1500)
#'
#' @param anc absolute neutrophil count (ANC), in number per microliter
#' 
#' @references \itemize{
#'   \item \href{https://link.springer.com/referenceworkentry/10.1007/978-3-642-16483-5_4052}{Neutropenia}: US National Cancer Institute's Common Toxicity Criteria
#' }
#'
#' @examples
#' calc_neutropenia_grade(
#'   anc = c(500, 1501)
#' )
#'
#' @export
calc_neutropenia_grade <- function(anc) {
  stage <- rep(NA, length(anc))
  stage[anc < 2000] <- 1
  stage[anc < 1500] <- 2
  stage[anc < 1000] <- 3
  stage[anc <  500] <- 4
  stage
}

