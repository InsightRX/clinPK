#' Calculate body surface area
#'
#' Get an estimate of body-surface area (in m2) based on weight and height
#'
#' @param weight weight
#' @param height height
#' @param method estimation method, choose from `dubois`, `mosteller`, `haycock`, `gehan_george`, `boyd`
#' @return Returns a list of the following elements:
#' \item{value}{Body Surface Area (BSA) in units of m2}
#' \item{unit}{Unit describing BSA, (m2)}
#' @examples
#' calc_bsa(weight = 70, height = 170)
#' calc_bsa(weight = 70, height = 170, method = "gehan_george")
#' @export
calc_bsa <- function (
  weight = NULL,
  height = NULL,
  method = c("dubois", "mosteller", "haycock", "gehan_george", "boyd")
  ) {
  
  method <- match.arg(method)
  if(is.null(weight)) {
    stop("Weight required for BSA estimation!")
  }
  if(is.null(height)) {
    stop("Height required for BSA estimation!")
  }
  
  unit <- "m2"
  bsa <- switch(
    method,
    "dubois" = (weight ^ 0.425 * height ^ 0.725) * 0.007184,
    "mosteller" = sqrt(height * weight / 3600),
    "haycock" = 0.024265 * height ^ 0.3964 * weight ^ 0.5378,
    "gehan_george" = 0.0235 * height ^ 0.42246 * weight ^ 0.51456,
    "boyd" = prod(
      0.0003207 * height ^ 0.3,
      (weight * 1000) ^ (0.7285 - (0.0188 * log10(weight * 1000)))
    )
  )
  list(
    value = bsa,
    unit = unit
  )
}

