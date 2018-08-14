#' Calculate AKI stage
#'
#' Calculate AKI class based on serum creatinine values over time, using various
#' methods for children (pRIFLE) and adults (RIFLE, kDIGO)
#'
#' Notes:
#' - will only take serum creatinine into account
#' - full serum creatinine history (at least up to 7 days prior) has to be provided.
#' - `egfr` and `age` are optional arguments, will only be taken into account if supplied, no warning is shown if not supplied.
#'
#' KDIGO AKI definition:
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
#' @param method classification method, one of `KDIGO`, `AKIN`, `RIFLE`, `pRIFLE`
#' @param baseline_scr baseline serum creatinine, required for `RIFLE` classifation. Will take median of `scr` values if `NULL`.
#' @param baseline_egfr baseline eGFR, required for `AKIN`, `RIFLE`, and `pRIFLE` classifations. Will take median of `egfr` values if `NULL`.
#' @param age age in years, needed when eGFR is used in the classification method
#' @param egfr eGFR in ml/min/1.73m^2. Optional, can also be calcualted if `age`, `weight`, `height`, `sex`, `egfr_method` are specified as arguments.
#' @param egfr_method eGFR calculation method, used by `calc_egfr()`
#' @param recursive option for KDIGO classification method only. Use recursive calculation (if `FALSE` will only take last observation into account)
#' @param verbose verbose (`TRUE` or `FALSE`)
#' @param ... arguments passed on to `calc_egfr()`
#' @examples
#' calc_aki_stage(scr = c(0.7, 0.9, 1.8, 1.5), t = c(0, 40, 100, 130))
#' @export
calc_aki_stage <- function (
  scr = NULL,
  times = NULL,
  method = "kDIGO",
  baseline_scr = NULL,
  baseline_egfr = NULL,
  age = NULL,
  egfr = NULL,
  egfr_method = "cockcroft_gault",
  recursive = TRUE,
  verbose = FALSE,
  ...
) {
  aki_detected <- FALSE
  aki_stage <- 0

  ## Checks
  if(is.null(scr)) stop("No serum creatinine values provided.")
  if(is.null(times)) stop("No sample times (days) provided.")
  if(class(times) == "Date") {
    times <- times[order(times)]
    times <- as.numeric(difftime(times, min(times), units = "days"))
  }
  if(!class(times[1]) %in% c("numeric","integer")) {
    stop("`times` argument should be supplied either as days (numeric) or as Date class.")
  }
  if(length(scr) != length(times)) stop("Serum creatinine values and vector of sample times should have same length.")
  if(!is.null(egfr)) {
    if(is.null(age)) stop("Also need age when eGFR is not provided as argument.")
    if(length(egfr) != length(scr)) stop("Serum creatinine values and vector of eGFR values should have same length.")
  }

  available_methods <- c("RIFLE", "pRIFLE", "kDIGO")
  if(!tolower(method) %in% tolower(available_methods)) {
    stop(paste0("AKI classification method not recognized, please select one from: ",
                paste(available_methods, collapse = " ")))
  }

  if(tolower(method) %in% c("rifle", "prifle")) {
      if(is.null(baseline_scr)) {
        baseline_scr <- stats::median(scr)
        warning("No baseline SCr value specified, using median of supplied values.")
      }
      if(is.null(egfr)) {
        egfr <- calc_egfr(
          scr = scr,
          times = times,
          method = egfr_method,
          age = age,
          ...
        )$value
      }
      if(is.null(baseline_egfr)) {
        baseline_egfr <- stats::median(egfr)
        warning("No baseline eGFR value specified, using median of supplied values.")
      }

      ## calculation
      dat <- data.frame(scr = scr, egfr = egfr, t = times, deltat = c(0, diff(times)))
      dat$baseline_scr_diff <- (dat$scr - baseline_scr)
      dat$baseline_scr_reldiff <- dat$baseline_scr_diff / baseline_scr
      dat$baseline_egfr_diff <- (dat$egfr - baseline_egfr)
      dat$baseline_egfr_reldiff <- dat$baseline_egfr_diff / baseline_egfr
      dat$stage <- NA

      dat$stage[dat$baseline_egfr_reldiff < -0.25] <- "R"
      if(method == "rifle") dat$stage[dat$baseline_scr_reldiff > 1.5] <- "R"

      dat$stage[dat$baseline_egfr_reldiff < -0.5] <- "I"
      if(method == "rifle") dat$stage[dat$baseline_scr_reldiff > 2.0] <- "I"

      dat$stage[dat$baseline_egfr_reldiff < -0.75 | dat$egfr < 35] <- "F"
      if(method == "rifle") dat$stage[dat$baseline_scr_reldiff > 3.0] <- "F"
      if(method == "rifle") dat$stage[dat$scr > 4.0 && max(diff(dat$scr) > 0.5)] <- "F"

      ## get max class:
      stage <- "none"
      if(any(dat$stage == "R", na.rm = TRUE)) stage <- "R"
      if(any(dat$stage == "I", na.rm = TRUE)) stage <- "I"
      if(any(dat$stage == "F", na.rm = TRUE)) stage <- "F"

      ## return object
      obj <- list(
        stage = stage,
        data = dat,
        method = method
      )
  }

  ## KDIGO considers changes in last 7 days, so function needs to be retrospective
  if(tolower(method) == "kdigo") {
    if(recursive && length(scr) > 1) {
      ## Do recursively
      all <- list()
      for(i in seq(scr)) {
        tmp <- calc_aki_stage(scr = scr[1:i],
                              times = times[1:i],
                              age = age,
                              egfr = egfr[1:i],
                              recursive = FALSE,
                              verbose = verbose)
        all <- rbind(all, tmp)
      }
      return(list(
        stage = max(all$stage),
        data = all,
        method = method
      ))
    } else {

      ## Detect if AKI
      dat <- data.frame(scr = scr, t = times, deltat = c(0, diff(times)))
      dat$scr <- ifelse(dat$scr < 0.01, 0.01, dat$scr)
      dat$baseline_incr <- scr / scr[1]
      dat <- dat[order(dat$t), ]

      # Detection rules
      t_max <- max(dat$t)
      tmp1 <- dat[dat$t >= (t_max - 48),]
      rule1 <- (max(tmp1$scr) - min(tmp1$scr)) >= 0.3
      tmp2 <- dat[dat$t >= (t_max - 168),]
      rule2 <- max(tmp2$baseline_incr) >= 1.5
      # rule3: not implemented (urinary volume)
      rule4 <- FALSE
      if(!is.null(egfr)) {
        rule4 <- tail(egfr,1) < 35
      }
      if(rule1 || rule2 || rule4) aki_detected <- TRUE

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
  return(obj)
}
