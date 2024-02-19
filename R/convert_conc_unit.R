#' Convert concentration units
#'
#' Lower-level function called by `convert_creat_unit()`,
#' `convert_albumin_unit()`, and others.
#'
#' @keywords internal
#' @seealso valid_units
#' @param value Value to convert
#' @param unit_in Input unit
#' @param unit_out Output unit
#' @param mol_weight Molecular weight in g/mol (required if converting to/from molar units)
convert_conc_unit <- function(value, unit_in, unit_out, mol_weight = NULL) {
  if (any(grepl("mol", unit_in)) | any(grepl("mol", unit_out))) {
    if (is.null(mol_weight)) {
      stop(
        "Molecular weight required when converting to/from molar units",
        call. = FALSE
      )
    }
  }
  if (length(unit_out) > 1) {
    stop("Output unit must be length 1")
  }
  if (length(unit_in) != length(value) && length(unit_in) != 1) {
    stop("length of unit_in must be either 1 or the same as values")
  }
  conv <- c(
    g_dl         = 10000000,
    `g/dl`       = 10000000,
    g_l          = 1000000,
    `g/l`        = 1000000,
    mg_dl        = 10000,
    `mg/dl`      = 10000,
    `micromol/l` = mol_weight,
    micromol_l   = mol_weight,
    micromol     = mol_weight,
    mmol         = mol_weight,
    `mumol/l`    = mol_weight,
    `umol/l`     = mol_weight,
    mumol_l      = mol_weight,
    umol_l       = mol_weight
  )

  unit_out <- match.arg(unit_out, names(conv))
  unrecognized_units <- setdiff(unit_in, names(conv))
  if (length(unrecognized_units) > 0) {
    # can't use match.arg here because if one unit is valid but another is
    # invalid it will silently just keep the valid one
    stop(
      paste0("Unrecognized unit: ", paste0(unrecognized_units, collapse = ", ")),
      call. = FALSE
    )
  }

  list(
    value = value * unname(conv[unit_in]) / unname(conv[unit_out]),
    unit = unit_out
  )
}
