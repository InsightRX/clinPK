#' Estimate serum creatinine in neonates
#'
#' Calculate an estimated serum creatinine. Function takes vectorized input as well.
#'
#' Uses equations described in Germovsek E et al. (http://www.ncbi.nlm.nih.gov/pubmed/27270281)
#' based on data from Cuzzolin et al. (http://www.ncbi.nlm.nih.gov/pubmed/16773403) and
#' Rudd et al. (http://www.ncbi.nlm.nih.gov/pubmed/6838252)
#'
#' @param pma post-natal age in weeks
#' @param digits number of digits to round to
#' @examples
#' cr <- calc_creat_neo(pma = 36)
#' convert_creat_unit(cr$value, unit_in = cr$unit, unit_out = "mg/dL")
#' @export
calc_creat_neo <- function (
  pma = NULL,
  digits = 1
) {
  if(is.null(pma)) {
    stop("PMA required required.")
  }
  if(any(pma < 25)) {
    stop("PMA < 25 not supported by this equation!")
  }
  if(any(pma > 42)) {
    stop("PMA >42 not supported by this equation!")
  }
  scr <- 166.48 - 2.849 * pma
  return(list(
    value = round(scr, digits),
    unit = "micromol/L"
  ))
}
