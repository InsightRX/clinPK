#' Calculate body surface area
#'
#' Get an estimate of body-surface area based on weight and height
#'
#' @param weight weight
#' @param height height
#' @param method estimation method, choose from `dubois`, `mosteller`, `haycock`, `gehan_george`, `boyd`
#' @export
calc_bsa <- function (
  weight = NULL,
  height = NULL,
  method = "dubois"
  ) {
    available_methods <- c("dubois", "mosteller", "haycock", "gehan_george", "boyd")
    method <- tolower(method)
    if(method %in% available_methods) {
      if(is.null(weight)) {
        stop("Weight required for BSA estimation!")
      }
      if(is.null(height)) {
        stop("Height required for BSA estimation!")
      }
      if(method == "dubois") {
        bsa <- (weight^0.425 * height^0.725) * 0.007184
      }
      if(method == "mosteller") {
        bsa <- sqrt(height * weight / 3600)
      }
      if(method == "haycock") {
        bsa <- 0.024265 * height^0.3964 * weight^0.5378
      }
      if(method == "gehan_george") {
        bsa <- 0.0235 * height^0.42246 * weight^0.51456
      }
      if(method == "boyd") {
        bsa <- 0.0003207 * height^0.3 * (weight/1000)^(0.7285-(0.0188*log(weight/1000)))
      }
      return(list(
        value = bsa,
        unit = "m2"
      ))
    } else {
      stop(paste0("Requested BSA estimation (", method,") method not found, please choose from: ", paste(available_methods, collapse=" ")))
    }
  }

