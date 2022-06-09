#' Calculate eGFR
#'
#' Calculate the estimated glomerular filtration rate (an indicator of renal 
#' function) based on measured serum creatinine using one of the following 
#' approaches:
#' \itemize{
#'   \item Cockcroft-Gault (using weight, ideal body weight, or adjusted body weight)
#'   \item C-G spinal cord injury (using correction factor of 0.7, representing 
#'     median correction point reported in the original publication (parapalegic
#'     patients: 0.8; tetrapalegic patients: 0.6))
#'   \item Revised Lund-Malmo
#'   \item Modification of Diet in Renal Disease study (MDRD; 
#'     with or without consideration of race, using either the original equation 
#'     (published 2001) or the equation updated to reflect serum creatinine 
#'     assay standardization (2006))
#'   \item CKD-EPI (with or without consideration of race, or 2021 re-fit without race)
#'   \item Schwartz
#'   \item Schwartz revised / bedside
#'   \item Jelliffe
#'   \item Jelliffe for unstable renal function. Note that the 15% reduction in 
#'     P_adj recommended for hemodialysis patients is not included in this 
#'     implementation.
#'   \item Wright equation for eGFR in cancer patients, with creatinine measured
#'     using the Jaffe assay.
#' }
#' Equations for estimation of eGFR from Cystatin C concentrations are available from the `calc_egfr_cystatin()` function.
#'
#' @param method eGFR estimation method, choose from `cockcroft_gault`, `cockcroft_gault_ideal`, 
#'   `cockcroft_gault_adjusted`, `cockcroft_gault_adaptive`, `mdrd`, 
#'   `mdrd_ignore_race`, `mdrd_original`, `mdrd_original_ignore_race`, 
#'   `ckd_epi`, `ckd_epi_ignore_race`, `ckd_epi_as_2021`,
#'   `malmo_lund_revised`, `schwartz`, `jelliffe`, `jellife_unstable`, `wright`.
#' @param sex sex
#' @param age age, in years
#' @param scr serum creatinine (mg/dL)
#' @param scr_unit, `mg/dL` or `micromol/L` (==`umol/L`)
#' @param race `black` or `other`, Required for CKD-EPI and MDRD methods for estimating GFR. 
#'   To use these methods without race, use `method = "ckd_epi_ignore_race"`,  `method = "ckd_epi_as_2021"`,
#'   `method = "mdrd_ignore_race"` or `method = "mdrd_original_ignore_race"`.
#'   See Note section below for important considerations when using race as a predictive factor in eGFR.
#' @param weight weight, in `kg`
#' @param height height, in `cm`, used for converting to/from BSA-normalized units.
#' @param bsa body surface area
#' @param bsa_method BSA estimation method, see `calc_bsa()` for details
#' @param times vector of sampling times (in days!) for creatinine (only used in Jelliffe equation for unstable patients)
#' @param ckd chronic kidney disease? Used for Schwartz method.
#' @param relative `TRUE`/`FALSE`. Report eGFR as per 1.73 m2? Requires BSA if re-calculation required. If `NULL` (=default), will choose value typical for `method`.
#' @param unit_out `ml/min` (default), `L/hr`, or `mL/hr`
#' @param preterm is patient preterm? Used for Schwartz method.
#' @param min_value minimum value (`NULL` by default). The cap is applied in the same unit as the `unit_out`.
#' @param max_value maximum value (`NULL` by default). The cap is applied in the same unit as the `unit_out`.
#' @param verbose verbosity, show guidance and warnings. `TRUE` by default
#' @param fail invoke `stop()` if not all covariates available?
#' @param ... arguments passed on to `calc_abw` or `calc_dosing_weight`
#' @references \itemize{
#'   \item Cockcroft-Gault: \href{https://pubmed.ncbi.nlm.nih.gov/1244564/}{Cockcroft & Gault, Nephron (1976)}
#'   \item Cockcroft-Gault for spinal cord injury: \href{https://pubmed.ncbi.nlm.nih.gov/6835689/}{Mirahmadi et al., Paraplegia (1983)}
#'   \item Revised Lund-Malmo: \href{https://pubmed.ncbi.nlm.nih.gov/24334413/}{Nyman et al., Clinical Chemistry and Laboratory Medicine (2014)}
#'   \item MDRD: \href{https://pubmed.ncbi.nlm.nih.gov/11706306/}{Manjunath et al., Curr. Opin. Nephrol. Hypertens. (2001)} 
#'     and \href{https://academic.oup.com/clinchem/article/53/4/766/5627682}{Levey et al., Clinical Chemistry (2007)}. (See Note.)
#'   \item CKD-EPI: \href{https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2763564/}{Levey et al., Annals of Internal Medicine (2009)}. (See Note.)
#'   \item CKD-EPI (2021): \href{https://www.nejm.org/doi/full/10.1056/NEJMoa2102953}{Inker, et al., NEJM (2021)}.
#'   \item Schwartz: \href{https://pubmed.ncbi.nlm.nih.gov/951142/}{Schwartz et al., Pediatrics (1976)}
#'   \item Schwartz revised / bedside: \href{https://pubmed.ncbi.nlm.nih.gov/19158356/}{Schwartz et al., Journal of the American Society of Nephrology (2009)}
#'   \item Jelliffe: \href{https://pubmed.ncbi.nlm.nih.gov/4748282/}{Jelliffe, Annals of Internal Medicine (1973)}
#'   \item Jelliffe for unstable renal function: \href{https://pubmed.ncbi.nlm.nih.gov/12169862/}{Jelliffe, American Journal of Nephrology (2002)}
#'   \item Wright: \href{https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2363765/}{Wright et al., British Journal of Cancer (2001)}
#' }
#' @note 
#'   The MDRD and CKD-EPI equations use race as a factor in estimation of GFR. Racism has
#'   historically been and continues to be a problem in medicine, with racialized patients
#'   experiencing poorer outcomes. Given this context, the use of race in clinical algorithms
#'   should be considered carefully (\href{https://www.nejm.org/doi/10.1056/NEJMms2004740}{Vyas et al., NEJM (2020)}).
#'   Provided here are versions of the CKD-EPI and MDRD equations that do not consider the race
#'   of the patient. Removing race from GFR estimation may lead to worse outcomes for Black patients 
#'   in some contexts (\href{https://www.thelancet.com/journals/lanonc/article/PIIS1470-2045(21)00377-6/fulltext}{Casal et al., The Lancet (2021)}). 
#'   On the other hand, including race in GFR estimation may also prevent Black patients 
#'   from obtaining procedures like kidney transplants
#'   ({\href{https://pubmed.ncbi.nlm.nih.gov/33443583/}{Zelnick, et al. JAMA Netw Open. (2021)}}).
#'   In 2021, the NKF/ASN Task Force on Reassessing the Inclusion of Race in Diagnosing Kidney Diseases
#'   published revised versions of the CKD-EPI equations refit on the original data but with race excluded, 
#'   which may produce less biased estimates 
#'   (\href{https://www.nejm.org/doi/full/10.1056/NEJMoa2102953}{Inker, et al., NEJM (2021)}).
#'  
#' @examples
#' calc_egfr(sex = "male", age = 50, scr = 1.1, weight = 70)
#' calc_egfr(sex = "male", age = 50, scr = 1.1, weight = 70, unit_out = "L/hr")
#' calc_egfr(sex = "male", age = 50, scr = 1.1, weight = 70, bsa = 1.8, method = "ckd_epi")
#' calc_egfr(sex = "male", age = 50, scr = c(1.1, 0.8),
#'   weight = 70, height = 170, method = "jelliffe")
#' calc_egfr(sex = "male", age = 50, scr = c(1.1, 0.8),
#'   weight = 70, height = 170, method = "jelliffe_unstable")
#' calc_egfr(sex = "male", age = 50, scr = 1.1,
#'   weight = 70, bsa = 1.6, method = "malmo_lund_revised", relative = FALSE)
#' @export
calc_egfr <- function (
  method = "cockcroft_gault",
  sex = NULL,
  age = NULL,
  scr = NULL,
  scr_unit = NULL,
  race = "other",
  weight = NULL,
  height = NULL,
  bsa = NULL,
  preterm = FALSE,
  ckd = FALSE,
  times = NULL,
  bsa_method = "dubois",
  relative = NULL,
  unit_out = "mL/min",
  verbose = TRUE,
  min_value = NULL,
  max_value = NULL,
  fail = TRUE,
  ...
){


  # Format output units
  # ---- Relative eGFR?
  if (is.nil(relative)) {
    # By default, assume true, since most equations report in units of /1.73m2.
    # Cockcroft-Gault and derived formulae do not report in relative units, but
    # do not require bsa to convert.
    relative <- ifelse(grepl('cockcroft_gault', method), FALSE, TRUE)
  }
  
  # Extract required covariates and tidied method name
  # --------------------------------------------------
  cov_reqs <- egfr_cov_reqs(method, relative)
  method <- names(cov_reqs)
  cov_reqs <- cov_reqs[[1]]

  # Convert units, tidy covariates, calculate intermediates if required
  # -------------------------------------------------------------------

  # ---- Calculate BSA
  if("bsa" %in% cov_reqs && is.nil(bsa)) { 
    calculate_egfr <- check_covs_available(c('height', 'weight'), 
                          list(height = height, weight = weight), fail = fail)
    if(!fail && !calculate_egfr) {
      return(FALSE)
    }
    bsa <- calc_bsa(weight, height, bsa_method)$value
  }

  # ---- Convert Creatinine
  if (is.null(scr_unit)) {
    if(verbose) message("Creatinine unit not specified, assuming mg/dL.")
    scr_unit <- "mg/dl"
  } else if (!(all(tolower(scr_unit) %in% valid_units("scr")))) {
    stop("Sorry, specified serum creatinine unit not recognized!")
  }
  if (length(scr_unit) == 1 && length(scr) > 1) {
    scr_unit <- rep(scr_unit, length(scr))
  }
  scr_unit <- tolower(gsub("%2F", "/", scr_unit))
  scr[scr_unit != "mg/dl"] <- scr[scr_unit != "mg/dl"] / 88.4

  # ---- Format Sex
  sex <- ifelse(is.nil(sex), '', tolower(sex))

  # Confirm Required Covariates Are Present
  # ---------------------------------------
  calculate_egfr <- check_covs_available(
    cov_reqs,
    list(
      age = age,
      sex = sex,
      creat = scr,
      weight = weight,
      height = height,
      bsa = bsa,
      race = race,
      preterm = preterm
      ),
    verbose = TRUE, 
    fail = fail
  )
  if (!(calculate_egfr)) {
    return(FALSE)
  }

  # Select Weight for eGFR
  # ----------------------
  if (grepl('cockcroft_gault_', method)) {

    if (grepl('_ideal', method)) {
      weight_for_egfr <- "Ideal BW"
      weight <- calc_ibw(weight = weight, height = height, age = age, sex = sex)

    } else if (grepl('_adjusted', method)) {
      weight_for_egfr <- "Adjusted BW"
      ibw <- calc_ibw(weight = weight, height = height, age = age, sex = sex)
      weight <- calc_abw(weight = weight, ibw = ibw, ...)

    } else if (grepl('_adaptive', method)) {
      tmp <- calc_dosing_weight(weight = weight,
                                height = height,
                                age = age,
                                sex = sex,
                                verbose = verbose,
                                ...)
      weight <- tmp$value
      weight_for_egfr <- tmp$type

    } else {
      weight_for_egfr <- "Total BW"
    }
  } else {
    weight_for_egfr <- "Total BW"
  }

  # Calculate eGFR
  # --------------

  if (grepl("cockcroft_gault(.*)(?<!sci)$", method, perl = TRUE)) {
    method <- "cockcroft_gault"
  }
  if (grepl("malmo", method) & grepl("lund", method)) {
    method <- "malmo_lund_revised"
  }

  crcl <- switch(
    method,
    "wright" = egfr_wright(age = age, bsa = bsa, sex = sex, scr = scr),
    "jelliffe" = egfr_jelliffe(age = age, sex = sex, bsa = bsa, scr = scr),
    "jelliffe_unstable" = egfr_jelliffe_unstable(
      weight = weight,
      times = times,
      scr = scr,
      age = age,
      sex = sex
    ),
    "mdrd" = egfr_mdrd(
      sex = sex,
      race = race,
      scr = scr,
      age = age,
      use_race = TRUE,
      original_expression = FALSE
    ),
    "mdrd_original" = egfr_mdrd(
      sex = sex,
      race = race,
      scr = scr,
      age = age,
      use_race = TRUE,
      original_expression = TRUE
    ),
    "mdrd_ignore_race" = egfr_mdrd(
      sex = sex,
      race = race,
      scr = scr,
      age = age,
      use_race = FALSE,
      original_expression = FALSE
    ),
    "mdrd_original_ignore_race" = egfr_mdrd(
      sex = sex,
      race = race,
      scr = scr,
      age = age,
      use_race = FALSE,
      original_expression = TRUE
    ),
    "ckd_epi" = egfr_ckd_epi(
      sex = sex,
      race = race,
      scr = scr,
      age = age,
      use_race = TRUE
    ),
    "ckd_epi_ignore_race" = egfr_ckd_epi(
      sex = sex,
      race = race,
      scr = scr,
      age = age,
      use_race = FALSE
    ),
    "ckd_epi_as_2021" = egfr_ckd_epi_as_2021(
      sex = sex,
      scr = scr,
      age = age
    ),
    "cockcroft_gault_sci" = egfr_cockcroft_gault_sci(
      sex = sex,
      age = age,
      scr = scr,
      weight = weight
    ),
    "cockcroft_gault" = egfr_cockcroft_gault(
      sex = sex,
      age = age,
      scr = scr,
      weight = weight
    ),
    "malmo_lund_revised" = egfr_malmo_lund(
      sex = sex,
      age = age,
      scr = scr
    ),
    "bedside_schwartz" = egfr_bedside_schwartz(
      age = age,
      height = height,
      scr = scr,
      verbose = verbose
    ),
    "schwartz_revised" = egfr_bedside_schwartz(
      age = age,
      height = height,
      scr = scr,
      verbose = verbose
    ),
    "schwartz" = egfr_schwartz(
      age = age,
      preterm = preterm,
      sex = sex,
      height = height,
      scr = scr
    ),
    NULL
  )

  # Format Output
  # -------------
  unit <- tolower(unit_out)

  if (is.null(crcl)) {
    return(
      list(
        value = crcl,
        age = age,
        bsa = bsa,
        sex = sex,
        scr = scr,
        unit = unit,
        weight = weight_for_egfr,
        capped = list()
      )
    )
  }

  # --- Convert to relative if required
  if (!relative & !grepl('cockcroft_gault', method)) {
    crcl <- relative2absolute_bsa(crcl, bsa)[["value"]]
  } else if (relative & !grepl('cockcroft_gault', method)){
    unit <- paste0(unit, "/1.73m^2")
  } else if (relative) {
    unit <- paste0(unit, "/1.73m^2")
    crcl <- absolute2relative_bsa(crcl, bsa)[["value"]]
  }
  # --- Convert to /h or to L if required
  conversion_factor <- 1
  conversion_factor <- ifelse(grepl('/hr', unit), conversion_factor * 60, conversion_factor)
  conversion_factor <- ifelse(grepl('^l', unit), conversion_factor / 1000, conversion_factor)
  crcl <- conversion_factor * crcl

# --- Check min/max censoring
  capped <- list()
  if(!is.null(min_value)){
    idx <- crcl < min_value
    if(any(idx)) {
      crcl[idx] <- min_value
      capped$min_value <- min_value
      capped$min_n <- sum(idx)
      if(verbose) message(paste0(capped$min_n, " values were capped to minimum value of ", min_value))
    }
  }
  if(!is.null(max_value)){
    idx <- crcl > max_value
    if(any(idx)) {
      crcl[idx] <- max_value
      capped$max_value <- max_value
      capped$max_n <- sum(idx)
      if(verbose) message(paste0(capped$max_n, " values were capped to maximum value of ", max_value))
    }
  }

  # Return Output
  # -------------

  return(list(
    value = crcl,
    age = age,
    bsa = bsa,
    sex = sex,
    scr = scr,
    unit = unit,
    weight = weight_for_egfr,
    capped = capped
  ))
}

egfr_wright <- function(age, bsa, sex, scr) {
  if (!sex %in% c("male", "female")) {
    warning("This method requires sex to be one of 'male' or 'female'.")
    return(NULL)
  }
  ((6580 - (38.8 * age)) * bsa * (1-(0.168 * (sex == "female"))))/(scr * 88.42)
}

egfr_jelliffe <- function(age, sex, bsa, scr) {
  if (!sex %in% c("male", "female")) {
    warning("This method requires sex to be one of 'male' or 'female'.")
    return(NULL)
  }
  ((98 - 0.8*(age - 20)) * (1 - 0.01 * ifelse(sex == "male", 0, 1)) * bsa/1.73) / scr
}

egfr_jelliffe_unstable <- function(weight, times, scr, age, sex) {
  if (!sex %in% c("male", "female")) {
    warning("This method requires sex to be one of 'male' or 'female'.")
    return(NULL)
  }
  vol <- 4 * weight

  # for times, if null or negative or mismatch in times/scr length, assume one 
  # day difference otherwise, ensure times and scrs are sequential.
  if (is.null(times) || length(scr) != length(times)) {
    dt <- rep(1, length(scr))
  } else {
    scr <- scr[order(times)]
    times <- sort(times)
    dt <- c(1, diff(times))
  }

  # for first creatinine, use that value. for subsequent creatinines, use 
  # average of current and previous values.
  if (length(scr) == 1) {
    scr_diff <- 0
    scr_av <- scr
  } else {
    scr_diff <- c(0, diff(scr))
    padded_means <- 0.5 * c(scr[1], scr) + c(scr, tail(scr, 1)) * 0.5
    scr_av <- padded_means[1:length(padded_means) - 1]
  }

  # calculate creatinine production
  Fsex <- ifelse(sex == "male", 0.95, 0.9 * 0.95)
  E_mgkgday <- 29.305 - (0.203 * age)
  E_ <- E_mgkgday * weight
  P1 <- 1344.4 - 43.76 * scr_av
  P2 <- 1344.4 - 43.76 * 1.1
  R_ <- P1/P2
  P_adj <- E_ * R_ * Fsex
  # calculate crcl
  100 * (P_adj - vol * scr_diff/dt) / (scr_av * 1440)
}

#' @noRd
#' @param use_race whether to include race as a factor in the calculation (TRUE
#'   or FALSE); see note
#' @param original_expression whether the MDRD equation should use the 2001 
#'   coefficient (TRUE) or the 2006 coefficient (FALSE), which was updated for 
#'   standardization of the creatinine assay.
egfr_mdrd <- function(sex, race, scr, age, use_race, original_expression) {
  if (!sex %in% c("male", "female")) {
    warning("This method requires sex to be one of 'male' or 'female'.")
    return(NULL)
  }
  coeff <- ifelse(original_expression, 186, 175)
  f_sex <- ifelse(sex == 'female', 0.742, 1)
  f_race <- ifelse(race == 'black' && use_race == TRUE, 1.212, 1)
  coeff * scr^(-1.154) * f_sex * f_race * age^(-0.203)
}

egfr_ckd_epi <- function(sex, race, scr, age, use_race) {
  if (!sex %in% c("male", "female")) {
    warning("This method requires sex to be one of 'male' or 'female'.")
    return(NULL)
  }
  a1 <- ifelse(sex == 'female', -0.329, -0.411)
  K <- ifelse(sex == 'female', 0.7, 0.9)
  f_sex <- ifelse(sex == 'female', 1.018, 1)
  f_race <- ifelse(race == 'black' && use_race == TRUE, 1.159, 1)
  141 * ((scr/K) ^ ifelse(scr < K, a1, -1.209)) * 0.993^age * f_sex * f_race
}

egfr_ckd_epi_as_2021 <- function(sex, scr, age) {
  if (!sex %in% c("male", "female")) {
    warning("This method requires sex to be one of 'male' or 'female'.")
    return(NULL)
  }
  a1 <- ifelse(sex == 'female', -0.241, -0.302)
  K <- ifelse(sex == 'female', 0.7, 0.9)
  f_sex <- ifelse(sex == 'female', 1.012, 1)
  142 * ((scr/K) ^ ifelse(scr < K, a1, -1.200)) * 0.9938^age * f_sex
}

egfr_cockcroft_gault_sci <- function(sex, age, scr, weight) {
  if (!sex %in% c("male", "female")) {
    warning("This method requires sex to be one of 'male' or 'female'.")
    return(NULL)
  }
  f_sex <- ifelse(sex == 'female', 0.85, 1)
  0.7 * (f_sex * (140-age) / scr * (weight/72))
}

egfr_cockcroft_gault <- function(sex, age, scr, weight) {
  if (!sex %in% c("male", "female")) {
    warning("This method requires sex to be one of 'male' or 'female'.")
    return(NULL)
  }
  f_sex <- ifelse(sex == 'female', 0.85, 1)
  f_sex * (140-age) / scr * (weight/72)
}

egfr_malmo_lund <- function(sex, age, scr) {
  if (!sex %in% c("male", "female")) {
    warning("This method requires sex to be one of 'male' or 'female'.")
    return(NULL)
  }
  scr_cutoff <- ifelse(sex == 'female', 1.696833, 2.0362)
  intercept <- ifelse(sex == 'female', 2.5, 2.56)
  slope <- ifelse(
    scr >= scr_cutoff,
    -0.926,
    ifelse(sex == 'female', 1.06964, 0.855712)
  )
  cr_term <- ifelse(scr < scr_cutoff, scr_cutoff - scr, log(scr/scr_cutoff))
  x <- intercept + slope * cr_term
  exp(x - 0.0158*age + 0.438*log(age))
}

egfr_bedside_schwartz <- function(age, height, scr, verbose) {
  if(age < 1 && verbose) warning("This equation is not meant for patients < 1 years of age.")
  k <- 0.413
  (k * height) / scr
}

egfr_schwartz <- function(age, preterm, sex, height, scr) {
  if (age < 1 ) {
    k <- ifelse(preterm, 0.33, 0.45)
  } else if (age > 13) {
    if (!sex %in% c("male", "female")) {
      warning("This method requires sex to be one of 'male' or 'female'.")
      return(NULL)
    }
    k <- ifelse(sex == 'male', 0.7,  0.55)
  } else {
    k <- 0.55
  }
  (k * height) / scr
}
