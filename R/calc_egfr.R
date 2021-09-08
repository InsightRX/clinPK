#' Calculate eGFR
#'
#' Calculate the estimated glomerular filtration rate (an indicator of renal function) based on measured serum creatinine using one of the following approaches:
#' \itemize{
#'   \item Cockcroft-Gault (using weight, ideal body weight, or adjusted body weight)
#'   \item C-G spinal cord injury
#'   \item Revised Lund-Malmo
#'   \item Modification of Diet in Renal Disease study (MDRD; with or without consideration of race)
#'   \item CKD-EPI (with or without consideration of race)
#'   \item Schwartz
#'   \item Schwartz revised / bedside
#'   \item Jelliffe
#'   \item Jelliffe for unstable renal function
#'   \item Wright
#' }
#' Equations for estimation of eGFR from Cystatin C concentrations are available from the `calc_egfr_cystatin()` function.
#'
#' @param method eGFR estimation method, choose from `cockcroft_gault`, `cockcroft_gault_ideal`, 
#'   `cockcroft_gault_adjusted`, `cockcroft_gault_adaptive`, `mdrd`, `mdrd_ignore_race`, `ckd_epi`, `ckd_epi_ignore_race`, 
#'   `malmo_lund_revised`, `schwartz`, `jelliffe`, `jellife_unstable`, `wright`.
#' @param sex sex
#' @param age age, in years
#' @param scr serum creatinine (mg/dL)
#' @param scr_unit, `mg/dL` or `micromol/L` (==`umol/L`)
#' @param race `black` or `other`, Required for CKD-EPI and MDRD methods for estimating GFR. 
#'   To use these methods without race, use `method = "ckd_epi_ignore_race"` or `method = "mdrd_ignore_race"` 
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
#'   \item Cockcroft-Gault: \href{http://www.ncbi.nlm.nih.gov/pubmed/1244564}{Cockcroft & Gault, Nephron (1976)}
#'   \item Cockcroft-Gault for spinal cord injury: \href{https://www.ncbi.nlm.nih.gov/pubmed/6835689}{Mirahmadi et al., Paraplegia (1983)}
#'   \item Revised Lund-Malmo: \href{http://www.ncbi.nlm.nih.gov/pubmed/24334413}{Nyman et al., Clinical Chemistry and Laboratory Medicine (2014)}
#'   \item MDRD: \href{https://www.ncbi.nlm.nih.gov/pubmed/10075613}{Level et al., Annals of Internal Medicine}. (See Note.)
#'   \item CKD-EPI: \href{https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2763564/}{Levey et al., Annals of Internal Medicine (2009)}. (See Note.)
#'   \item Schwartz: \href{https://www.ncbi.nlm.nih.gov/pubmed/951142}{Schwartz et al., Pediatrics (1976)}
#'   \item Schwartz revised / bedside: \href{https://www.ncbi.nlm.nih.gov/pubmed/19158356}{Schwartz et al., Journal of the American Society of Nephrology (2009)}
#'   \item Jelliffe: \href{https://www.ncbi.nlm.nih.gov/pubmed/4748282}{Jelliffe, Annals of Internal Medicine (1973)}
#'   \item Jelliffe for unstable renal function: \href{https://www.ncbi.nlm.nih.gov/pubmed/4748282}{Jelliffe, American Journal of Nephrology (2002)}
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
#'   weight = 70, bsa = 1.6, method = "malmo_lund_rev", relative = FALSE)
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
  } else if (!(all(tolower(scr_unit) %in% c("mg/dl", "micromol/l", "mumol/l", "umol/l")))) {
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
  calculate_egfr <- check_covs_available(cov_reqs,
                                         list(age = age,
                                              sex = sex,
                                              creat = scr,
                                              weight = weight,
                                              height = height,
                                              bsa = bsa,
                                              race = race,
                                              preterm = preterm),
                                         verbose = TRUE, 
                                         fail = fail)
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
  crcl <- c()
  if (method == 'wright'){
    crcl <- ((74.4344 - (0.438914 * age)) * bsa * (1-(0.168*ifelse(sex == "male", 0, 1))))/scr

  } else if (method == "jelliffe") {
    crcl <- ((98 - 0.8*(age - 20)) * (1 - 0.01 * ifelse(sex == "male", 0, 1)) * bsa/1.73) / scr

  } else if (method == "jelliffe_unstable") {
    vol <- 4 * weight

    # for times, if null or negative or mismatch in times/scr length, assume one day difference
    # otherwise, ensure times and scrs are sequential.
    if (is.null(times) | length(scr) != length(times)) {
      dt <- rep(1, length(scr))
    } else {
      scr <- scr[order(times)]
      times <- sort(times)
      dt <- c(1, diff(times))
    }

    # for first creatinine, use that value. for subsequent creatinines, use average of current and previous values.
    if (length(scr) == 1) {
      scr_diff <- 0
      scr_av <- scr
    } else {
      scr_diff <- c(0, diff(scr)) * -1
      scr_av <- scr + scr_diff/2
    }

    # calculate creatinine production
    cr_prod <- (29.305-(0.203 * age)) * weight * (1.037-(0.0338 * scr_av)) * ifelse(sex == "male", 0.85, 0.765)
    # calculate crcl
    crcl <- ((vol * scr_diff/dt + cr_prod) * 100) / (1440 * scr_av)

  } else if (method == "mdrd") {
    f_sex <- ifelse(sex == 'female', 0.762, 1)
    f_race <- ifelse(race == 'black', 1.21, 1)
    crcl <- 186 * scr^(-1.154) * f_sex * f_race * age^(-0.203)
    
  } else if (method == "mdrd_ignore_race") {
    f_sex <- ifelse(sex == 'female', 0.762, 1)
    crcl <- 186 * scr^(-1.154) * f_sex * age^(-0.203)

  } else if (method == "ckd_epi"){
    f_sex <- ifelse(sex == 'female', 1.018, 1)
    f_race <- ifelse(race == 'black', 1.159, 1)
    crcl <- 141 * (scr ^ ifelse(scr < 1, -0.329, -1.209)) * 0.993^age * f_sex * f_race
    
  } else if (method == "ckd_epi_ignore_race"){
    f_sex <- ifelse(sex == 'female', 1.018, 1)
    crcl <- 141 * (scr ^ ifelse(scr < 1, -0.329, -1.209)) * 0.993^age * f_sex

  } else if (method == 'cockcroft_gault_sci') {
    f_sex <- ifelse(sex == 'female', 0.85, 1)
    crcl <- 2.3 * (f_sex * (140-age) / scr * (weight/72)) ^0.7

  } else if (grepl('cockcroft_gault', method)) {
    f_sex <- ifelse(sex == 'female', 0.85, 1)
    crcl <- f_sex * (140-age) / scr * (weight/72)

  } else if (grepl('malmo', method) & grepl('lund', method)) {
    scr_cutoff <- ifelse(sex == 'female', 1.696833, 2.0362)
    intercept <- ifelse(sex == 'female', 2.5, 2.56)
    slope <- ifelse(scr >= scr_cutoff, -0.926,
                    ifelse(sex == 'female', 1.06964, 0.855712))
    cr_term <- ifelse(scr < scr_cutoff, scr_cutoff - scr, log(scr/scr_cutoff))
    x <- intercept + slope * cr_term

    crcl <- exp(x - 0.0158*age + 0.438*log(age))

  } else if (method %in% c("bedside_schwartz", "schwartz_revised")) {
    if(age < 1 && verbose) message("This equation is not meant for patients < 1 years of age.")
    k <- 0.413
    crcl <- (k * height) / scr

  } else if (method == 'schwartz') {
    k <- ifelse(preterm & age < 1, 0.33,
                ifelse(age < 1, 0.45,
                       ifelse(age > 13 & sex == 'male', 0.7,
                               0.55)))
    crcl <- (k * height) / scr
  } else {
    return(FALSE)
  }

  # Format Output
  # -------------
  unit <- tolower(unit_out)

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
