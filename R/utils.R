#' Check for inconsistent vector lengths among inputs
#'
#' @param ... named arguments to check
#' @keywords internal
check_input_lengths <- function(...) {
  input_lengths <- lengths(Filter(
    function(x) !is.null(x) && length(x) > 1,
    list(...)
  ))
  if (length(unique(input_lengths)) > 1) {
    sizes <- paste(sprintf("`%s` (size %d)", names(input_lengths), input_lengths), collapse = ", ")
    stop(sprintf("Vector inputs must all be the same length: %s.", sizes))
  }
}

#' Resolve and validate inputs for a method-dispatched function
#'
#' Identifies required arguments for `fn`, auto-computes `bmi` from `height`
#' and `weight` when needed, then stops with an informative message if any
#' required argument is still missing.
#'
#' @param fn The inner method function to be called.
#' @param method Character string naming the method (used in error messages).
#' @param ... Named input arguments (e.g. weight, bmi, sex, height, age).
#' @return A named list of the supplied inputs, with `bmi` computed if needed.
#' @keywords internal
prepare_method_inputs <- function(fn, method, ...) {
  inputs <- list(...)

  # Detect required (no-default) arguments:
  fn_formals <- formals(fn)
  required <- names(fn_formals)[
    sapply(fn_formals, function(.x) identical(.x, alist(a = )[[1]]))
  ]

  # Auto-compute bmi from height + weight if bmi is required but not supplied:
  if ("bmi" %in% required && is.null(inputs$bmi) &&
      !is.null(inputs$height) && !is.null(inputs$weight)) {
    inputs$bmi <- calc_bmi(height = inputs$height, weight = inputs$weight)
  }

  # Check all required args are present:
  missing_args <- required[sapply(required, function(.x) is.null(inputs[[.x]]))]
  if (length(missing_args) > 0) {
    missing_labels <- ifelse(
      missing_args == "bmi", "bmi or weight and height", missing_args
    )
    stop(sprintf(
      "Method '%s' requires: %s.",
      method, paste(missing_labels, collapse = ", ")
    ))
  }

  inputs
}

#' Validate and normalize a sex argument
#'
#' Lowercases `sex` and checks every element is `"male"` or `"female"`. If
#' not, issues a warning and returns `NULL` so the calling function can
#' short-circuit with `return(NULL)`.
#'
#' @param sex Character vector.
#' @return Lowercased `sex`, or `NULL` (invisibly) after a warning.
#' @keywords internal
normalize_sex <- function(sex) {
  sex <- tolower(sex)
  if (length(sex) == 0 || !all(sex %in% c("male", "female"))) {
    warning("This method requires sex to be one of 'male' or 'female'.")
    return(NULL)
  }
  sex
}

#' Check if values in vector are empty
#'
#' @param x vector
#' @keywords internal
is.nil <- function(x = NULL) {
  return(is.null(x) || any(c(length(x) == 0, is.na(x), is.nan(x), x == "")))
}

#' factors or characters to numeric
#' @param x value
#' @keywords internal
as.num <- function(x) return (as.numeric(as.character(x)))

#' Remove less-than/greater-than symbols and convert to numeric
#'
#' The following characters will be removed from strings: <, >, =, space. If
#' string contains other characters, the original string will be returned.
#'
#' @keywords internal
#' @param x Vector of numbers possibly containing extraneous strings.
#' @return If non-numeric characters were successfully removed, returns a
#'   numeric vector. If some elements of `x` contained other characters, their
#'   original value will be returned and the result will be a character vector.
remove_lt_gt <- function(x) {
  if (!inherits(x, "character")) {
    return(x)
  }
  num_na <- sum(is.na(x))
  idx <- grep("[^<>=\\.-[:space:][:digit:]]+", x, invert = TRUE)
  x[idx] <- gsub("[<>=[:space:]]", "", x[idx])

  if (suppressWarnings(sum(is.na(as.numeric(x)))) > num_na) {
    return(x)
  } else {
    return(as.numeric(x))
  }
}

#' Greater-than-or-equal-to with a little room for floating point precision
#' issues
#'
#' @keywords internal
#' @param x Numeric vector
#' @param y Numeric vector
`%>=%` <- function(x, y) {
  if (length(x) == 0 | length(y) == 0) {
    return(logical(0))
  }
  x > y | mapply(function(x, y) isTRUE(all.equal(x, y)), x, y)
}

#' Less-than-or-equal-to with a little room for floating point precision
#' issues
#'
#' @keywords internal
#' @param x Numeric vector
#' @param y Numeric vector
#' @export
`%<=%` <- function(x, y) {
  if (length(x) == 0 | length(y) == 0) {
    return(logical(0))
  }
  x < y | mapply(function(x, y) isTRUE(all.equal(x, y)), x, y)
}
