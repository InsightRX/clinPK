#' Calculate eGFR based on creatinine and cystatin C measurements
#'
#' @description
#' Calculate the estimated glomerular filtration rate based on both measured
#' serum creatinine and serum cystatin C using one of the following approaches:
#'
#' - CKD-EPI creatinine-cystatin C (2021 re-fit without race). Developed in
#'   adults (>= 18 years) only.
#' - European Kidney Function Consortium (EKFC): the arithmetic mean of
#'   the creatinine-based and cystatin C-based EKFC equations. The cystatin
#'   C-based equation was validated in adults (>= 18 years) only.
#'
#' @param method eGFR estimation method, choose from `"ckd_epi_as_2021"`, `"ekfc"`.
#' @param sex sex
#' @param age age, in years
#' @param scr serum creatinine (mg/dL)
#' @param scr_unit `"mg/dL"` or `"micromol/L"` (==`"umol/L"`)
#' @param cystatin serum cystatin C concentration (mg/L)
#' @param cystatin_unit only `"mg/L"` available
#' @param weight weight, in `kg`, used for converting to absolute units.
#' @param height height, in `cm`, used for converting to absolute units.
#' @param bsa body surface area, used for converting to absolute units.
#' @param bsa_method BSA estimation method, see [calc_bsa()] for details
#' @param relative `TRUE`/`FALSE`. Report eGFR as per 1.73 m2? If `FALSE`,
#'   requires `bsa`, or `weight` and `height` to calculate it.
#' @param unit_out `"mL/min"` (default), `"mL/hr"`, `"L/min"`, or `"L/hr"`
#'   (case-insensitive)
#' @param min_value minimum value (`NULL` by default). The cap is applied in the same unit as the `unit_out`.
#' @param max_value maximum value (`NULL` by default). The cap is applied in the same unit as the `unit_out`.
#' @param verbose verbosity, show guidance and warnings. `TRUE` by default
#' @param fail invoke `stop()` if not all covariates available?
#' @references
#' - CKD-EPI (2021): [Inker, et al., NEJM (2021)](https://www.nejm.org/doi/full/10.1056/NEJMoa2102953).
#' - EKFC: [Pottel et al., NEJM (2023)](https://www.nejm.org/doi/full/10.1056/NEJMoa2203769)
#' @seealso
#' - [calc_egfr()] for equations using creatinine alone
#' - [calc_egfr_cystatin()] for equations using cystatin C alone
#' @examples
#' calc_egfr_combined(sex = "female", age = 50, scr = 0.9, cystatin = 1.1)
#' calc_egfr_combined(sex = "female", age = 50, scr = 0.9, cystatin = 1.1,
#'   method = "ekfc")
#' calc_egfr_combined(sex = "female", age = 50, scr = 0.9, cystatin = 1.1,
#'   weight = 70, height = 165, relative = FALSE, unit_out = "L/hr")
#' @export
calc_egfr_combined <- function(
  method = c("ckd_epi_as_2021", "ekfc"),
  sex = NULL,
  age = NULL,
  scr = NULL,
  scr_unit = NULL,
  cystatin = NULL,
  cystatin_unit = "mg/L",
  weight = NULL,
  height = NULL,
  bsa = NULL,
  bsa_method = "dubois",
  relative = TRUE,
  unit_out = "mL/min",
  verbose = TRUE,
  min_value = NULL,
  max_value = NULL,
  fail = TRUE
) {
  method <- gsub("-", "_", tolower(method))
  method <- match.arg(method)
  cov_reqs <- c("creat", "cystatin", "sex", "age")
  if (!relative) {
    cov_reqs <- c("bsa", cov_reqs)
  }

  # Calculate BSA if required -------------------------------------------------
  if ("bsa" %in% cov_reqs && is.nil(bsa)) {
    calculate_egfr <- check_covs_available(
      c("height", "weight"),
      list(height = height, weight = weight),
      fail = fail
    )
    if (!fail && !calculate_egfr) {
      return(FALSE)
    }
    bsa <- calc_bsa(weight, height, bsa_method)$value
  }

  # Confirm required covariates are present -----------------------------------
  calculate_egfr <- check_covs_available(
    cov_reqs,
    list(
      age = age,
      sex = sex,
      creat = scr,
      cystatin = cystatin,
      bsa = bsa
    ),
    verbose = TRUE,
    fail = fail
  )
  if (!(calculate_egfr)) {
    return(FALSE)
  }

  check_input_lengths(
    sex = sex,
    age = age,
    scr = scr,
    cystatin = cystatin,
    weight = weight,
    height = height,
    bsa = bsa
  )

  # Convert units, tidy covariates --------------------------------------------
  scr <- convert_egfr_scr(scr, scr_unit, verbose)
  cystatin <- convert_egfr_cystatin(cystatin, cystatin_unit, verbose)
  sex <- normalize_sex(sex)
  if (is.null(sex)) return(NULL)

  # Calculate eGFR ------------------------------------------------------------
  egfr <- switch(
    method,
    "ckd_epi_as_2021" = egfr_ckd_epi_combined_as_2021(
      sex = sex,
      scr = scr,
      cystatin = cystatin,
      age = age,
      verbose = verbose
    ),
    "ekfc" = egfr_ekfc_combined(
      sex = sex,
      scr = scr,
      cystatin = cystatin,
      age = age,
      verbose = verbose
    )
  )

  # Format output -------------------------------------------------------------
  out <- format_egfr_output(
    egfr = egfr,
    unit = tolower(unit_out),
    relative = relative,
    reported_relative = TRUE,
    bsa = bsa,
    min_value = min_value,
    max_value = max_value,
    verbose = verbose
  )

  list(
    value = out$value,
    age = age,
    bsa = bsa,
    sex = sex,
    scr = scr,
    cystatin = cystatin,
    unit = out$unit,
    capped = out$capped
  )
}

egfr_ckd_epi_combined_as_2021 <- function(sex, scr, cystatin, age, verbose = TRUE) {
  if (verbose && any(age < 18)) {
    warning(
      "The CKD-EPI creatinine-cystatin C equation was developed in adults ",
      "only (>= 18 years of age)."
    )
  }
  a1 <- ifelse(sex == "female", -0.219, -0.144)
  K <- ifelse(sex == "female", 0.7, 0.9)
  f_sex <- ifelse(sex == "female", 0.963, 1)
  135 *
    pmin(scr/K, 1)^a1 * pmax(scr/K, 1)^(-0.544) *
    pmin(cystatin/0.8, 1)^(-0.323) * pmax(cystatin/0.8, 1)^(-0.778) *
    0.9961^age * f_sex
}

egfr_ekfc_combined <- function(sex, scr, cystatin, age, verbose = TRUE) {
  egfr_cr <- egfr_ekfc_creat(sex = sex, scr = scr, age = age, verbose = FALSE)
  egfr_cys <- egfr_ekfc_cystatin(cystatin = cystatin, age = age, verbose = verbose)
  (egfr_cr + egfr_cys) / 2
}
