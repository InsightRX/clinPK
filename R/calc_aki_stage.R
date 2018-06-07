#' Calculate AKI stage
#'
#' Calculate stage of kidney injury, following definition from KDIGO (http://www.kdigo.org/clinical_practice_guidelines/pdf/KDIGO%20AKI%20Guideline.pdf).
#' Notes:
#' - will only take serum creatinine into account
#' - full serum creatinine history (at least up to 7 days prior) has to be provided.
#' - `egfr` and `age` are optional arguments, will only be taken into account if supplied, no warning is shown if not supplied.
#'
#' AKI definition:
#' AKI is defined as any of the following (
#'  - increase in SCr by >= 0.3 mg/dL within 48 hours
#'  - increase in SCr to >=1.5x baseline (baseline in prior 7 days)
#'  - urine volume < 0.5 ml/kg/h for 6 hours
#'
#' AKI Staging:
#' Stage 1: SCr 1.5–1.9 times baseline OR >=0.3 mg/dl (>=26.5 mmol/l) increase
#' Stage 2: SCr 2.0–2.9 times baseline
#' Stage 3: SCr 3.0 times baseline OR Initiation of RRT, OR, in patients < 18 y.o., decrease in GFR to <35 ml/min per 1.73m2
#'
#' @param scr serum creatinine in mg/dL. Use `convert_creat()` to convert from mmol/L.
#' @param times creatinine sample times in hours
#' @param age age in years
#' @param egfr eGFR in ml/min/1.73m^2
#' @param recursive recursive (if `FALSE` will only take last observation into account)
#' @param verbose verbose (`TRUE` or `FALSE`)
#' @examples
#' calc_aki_stage(scr = c(0.7, 0.9, 1.8, 1.5), times = c(0, 40, 100, 130), sex = "male", age = 40)
#' @export
calc_aki_stage <- function (
  scr = NULL,
  t = NULL,
  age = NULL,
  egfr = NULL,
  recursive = TRUE,
  verbose = FALSE
) {
  aki_detected <- FALSE
  aki_stage <- 0

  ## Checks
  if(is.null(scr)) stop("No serum creatinine values provided.")
  if(is.null(t)) stop("No sample time values provided.")
  if(length(scr) != length(t)) stop("Serum creatinine values and vector of sample times should have same length.")
  if(!is.null(egfr)) {
    if(is.null(age)) stop("Also need age when eGFR is provided")
    if(length(egfr) != length(scr)) stop("Serum creatinine values and vector of eGFR values should have same length.")
  }

  if(recursive) {
    ## Do recursively
    all <- list()
    for(i in seq(scr)) {
      tmp <- calc_aki_stage(scr = scr[1:i],
                            t = t[1:i],
                            age = age,
                            egfr = egfr[1:i],
                            recursive = FALSE,
                            verbose = verbose)
      all <- rbind(all, tmp)
    }
    return(data.frame(all))
  } else {
    ## Detect if AKI
    dat <- data.frame(scr = scr, t = t, deltat = c(0, diff(t)))
    dat$baseline_incr <- scr / scr[1]
    dat <- dat[order(dat$t), ]

    # Detection rules
    t_max <- max(dat$t)
    tmp1 <- dat[dat$t >= t_max - 48,]
    rule1 <- (max(tmp1$scr) - min(tmp1$scr)) >= 0.3
    tmp2 <- dat[dat$t >= t_max - 168,]
    rule2 <- max(tmp2$baseline_incr) >= 1.5
    # rule3: not implemented (urinary volume)
    if(rule1 || rule2) aki_detected <- TRUE

    ## Get stage
    if(aki_detected) {
      if(tail(dat$baseline_incr,1) >= 1.5) aki_stage <- 1
      if(rule1) aki_stage <- 1
      if(tail(dat$baseline_incr,1) >= 2.0) aki_stage <- 2
      if(tail(dat$baseline_incr,1) >= 3.0) aki_stage <- 3
      if(!is.null(egfr)) {
        if(age < 18) if(tail(egfr,1) < 35) aki_stage <- 3
      }
    }
    return(data.frame(
      t = tail(t,1),
      aki = aki_detected,
      stage = aki_stage
    ))
  }
}
