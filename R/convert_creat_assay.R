#' Convert serum creatinine from various assays to Jaffe
#'
#' Based on equations as reported in Srivastava et al. 2009 (Pediatr Res. 2009 Jan;65(1):113-6. doi: 10.1203/PDR.0b013e318189a6e8)
#'
#' @param scr vector of serum creatinine values
#' @param from assay type, either `jaffe`, `enzymatic` or `idms`
#' @param to assay type, either `jaffe`, `enzymatic` or `idms`
#' @examples
#' convert_creat_assay(scr = c(1.1, 0.8, 0.7), from = "enzymatic", to = "jaffe")
#' @export
convert_creat_assay <- function(
  scr,
  from = "idms",
  to = "jaffe") {

  scr_orig <- scr
  if(is.null(from) || is.null(to) || any(is.null(scr))) {
    warning("Can't convert creatinine values, some value is NULL. Returning untransformed values.")
    return(scr)
  }

  ## first convert everything to jaffe
  if (tolower(from) %in% c("enzymatic", "enzym")) {  # default is Jaffe method
     scr <- (scr + 0.112) / 1.05
  }
  if (tolower(from) %in% c("enzymatic_idms", "idms")) {
     scr <- (scr + 0.254) / 1.027
  }

  ## convert to other, if required
  if (tolower(to) %in% c("enzymatic", "enzym")) {  # default is Jaffe method
    scr <- (scr * 1.05) - 0.112
  }
  if (tolower(to) %in% c("enzymatic_idms", "idms")) {
    scr <- (scr * 1.027) - 0.254
  }
  if(any(scr < 0.1)) {
    scr[scr < 0.1] <- 0.1
    warning(paste0("Can't reliably convert creatinine value <0.1 between assays, returning 0.1 for thoses values."))
  }
  return(scr)
}
