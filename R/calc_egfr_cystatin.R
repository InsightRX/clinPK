#' Calculate eGFR based on Cystatin C measurements
#'
#' @param method eGFR estimation method, choose from `"grubb"`, `"larsson"`, `"hoek"`,
#'   `"ekfc"`, `"ckd_epi"`
#' @param cystatin serum cystatin concentration (mg/L)
#' @param cystatin_unit only `"mg/L"` available
#' @param unit_out eGFR output unit, choose from `"ml/min"`, `"ml/hr"`, `"l/min"`,
#'   `"l/hr"`, `"ml/min/1.73m2"`. The Hoek, EKFC, and CKD-EPI methods only support
#'   `"ml/min/1.73m2"`.
#' @param age age, in years. Required for the `"ekfc"` and `"ckd_epi"` methods.
#' @param sex sex, `"male"` or `"female"`. Required for the `"ckd_epi"` method.
#' @param verbose verbosity, show guidance and warnings. `TRUE` by default
#' @references
#' - EKFC: [Pottel et al., NEJM (2023)](https://www.nejm.org/doi/full/10.1056/NEJMoa2203769).
#'   Validated in adults (>= 18 years) only.
#' - CKD-EPI (2012): [Inker et al., NEJM (2012)](https://www.nejm.org/doi/full/10.1056/NEJMoa1114248)
#' @seealso
#' - [calc_egfr()] for equations using creatinine alone
#' - [calc_egfr_combined()] for equations using both creatinine and Cystatin C
#' @examples
#' calc_egfr_cystatin(1.0)
#' calc_egfr_cystatin(1.0, method = "larsson")
#' calc_egfr_cystatin(1.0, unit_out = "l/hr")
#' calc_egfr_cystatin(1.0, method = "ekfc", unit_out = "ml/min/1.73m2", age = 50)
#' calc_egfr_cystatin(1.0, method = "ckd_epi", unit_out = "ml/min/1.73m2",
#'   age = 50, sex = "female")
#' @export
calc_egfr_cystatin <- function (
  cystatin = NULL,
  cystatin_unit = "mg/L",
  method = c("grubb", "larsson", "hoek", "ekfc", "ckd_epi"),
  unit_out = c("ml/min", "ml/hr", "l/min", "l/hr", "ml/min/1.73m2"),
  age = NULL,
  sex = NULL,
  verbose = TRUE
) {
  method <- gsub("-", "_", tolower(method))
  unit_out <- tolower(unit_out)
  method <- match.arg(method)
  unit_out <- match.arg(unit_out)
  cystatin <- convert_egfr_cystatin(cystatin, cystatin_unit, verbose)

  # Check output unit is supported by method ----------------------------------
  # These methods report eGFR per 1.73 m2, and can't be converted without BSA.
  relative_methods <- c(hoek = "Hoek", ekfc = "EKFC", ckd_epi = "CKD-EPI")
  if (method %in% names(relative_methods) && unit_out != "ml/min/1.73m2") {
    stop(paste0(
      "For ", relative_methods[[method]],
      " method, the `unit_out` needs to be mL/min/1.73m2."
    ))
  }
  if (!(method %in% names(relative_methods)) && unit_out == "ml/min/1.73m2") {
    stop("Output unit not supported for this method.")
  }

  # Confirm required covariates are present -----------------------------------
  cov_reqs <- switch(
    method,
    "ekfc" = "age",
    "ckd_epi" = c("age", "sex"),
    NULL
  )
  check_covs_available(cov_reqs, list(age = age, sex = sex))
  check_input_lengths(
    cystatin = cystatin,
    age = age,
    sex = sex
  )
  if ("sex" %in% cov_reqs) {
    sex <- normalize_sex(sex)
    if (is.null(sex)) return(NULL)
  }

  # Calculate eGFR ------------------------------------------------------------
  egfr <- switch(
    method,
    "grubb" = egfr_grubb_cystatin(cystatin = cystatin),
    "larsson" = egfr_larsson_cystatin(cystatin = cystatin),
    "hoek" = egfr_hoek_cystatin(cystatin = cystatin),
    "ekfc" = egfr_ekfc_cystatin(cystatin = cystatin, age = age, verbose = verbose),
    "ckd_epi" = egfr_ckd_epi_cystatin(cystatin = cystatin, sex = sex, age = age)
  )

  # Format output -------------------------------------------------------------
  if (length(grep("^l/min", tolower(unit_out))) > 0) {
    egfr <- egfr / 1000
  }
  if (length(grep("^l/hr", tolower(unit_out))) > 0) {
    egfr <- egfr * 60 / 1000
  }
  if (length(grep("^ml/hr", tolower(unit_out))) > 0) {
    egfr <- egfr * 60
  }
  return(list(
    value = egfr,
    unit = unit_out
  ))
}

#' Convert serum cystatin C to mg/L for eGFR equations
#'
#' Only `mg/L` is currently supported, so this validates `cystatin_unit` and
#' returns `cystatin` unchanged.
#'
#' @inheritParams calc_egfr_cystatin
#' @returns serum cystatin C in mg/L
#' @noRd
convert_egfr_cystatin <- function(cystatin, cystatin_unit, verbose = TRUE) {
  if (is.null(cystatin_unit) || length(cystatin_unit) == 0 || all(is.na(cystatin_unit))) {
    if(verbose) message("Cystatin C unit not specified, assuming mg/L.")
    cystatin_unit <- "mg/l"
  }
  if (!all(tolower(cystatin_unit) == "mg/l")) {
    stop("Sorry, only `mg/L` is supported for `cystatin_unit`.")
  }
  cystatin
}

egfr_grubb_cystatin <- function(cystatin) {
  83.93 * cystatin^(-1.676)
}

egfr_larsson_cystatin <- function(cystatin) {
  77.239 * cystatin^(-1.2623)
}

egfr_hoek_cystatin <- function(cystatin) {
  -4.32 + (80.35/cystatin)
}

#' @noRd
#' @return Q value for EKFC cystatin C equation, in mg/L
ekfc_q_cystatin <- function(age) {
  0.83 + 0.005 * pmax(age - 50, 0)
}

egfr_ekfc_cystatin <- function(cystatin, age, verbose = TRUE) {
  if (verbose && any(age < 18)) {
    warning("The EKFC cystatin C equation was validated in adults only (>= 18 years of age).")
  }
  egfr_ekfc(cystatin, ekfc_q_cystatin(age), age)
}

egfr_ckd_epi_cystatin <- function(cystatin, sex, age) {
  f_sex <- ifelse(sex == "female", 0.932, 1)
  133 *
    pmin(cystatin/0.8, 1)^(-0.499) * pmax(cystatin/0.8, 1)^(-1.328) *
    0.996^age * f_sex
}
