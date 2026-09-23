# AGENTS.md

This file provides guidance to AI coding agents working with code in this
repository. It is harness-agnostic: any agent tooling that reads project
instructions should use this file.

## Overview

clinPK is a CRAN R package providing equations used in clinical
pharmacokinetics and clinical pharmacology: dose individualization,
compartmental PK, drug exposure, anthropometric calculations, clinical
chemistry, and unit conversion of common clinical parameters. It is a pure-R
package with **no runtime dependencies** (`Depends: R (>= 2.10)`, `Suggests:
testthat`). Keep it that way — do not add package dependencies without a
strong reason.

The defining design goal: where several published, peer-reviewed equations
exist for the same quantity, a single exported function offers all of them
behind a `method` argument rather than exposing one function per publication.

## Commands

All commands run from the package root.

```r
devtools::test()                        # run the full test suite
devtools::test(filter = "calc_egfr")    # run matching test files (regex on the name after "test-"/"test_")
devtools::load_all()                    # load the package for interactive work
devtools::document()                    # regenerate man/*.Rd and NAMESPACE from roxygen comments
devtools::check()                       # full R CMD check
pkgdown::build_site()                   # build the pkgdown site locally
```

Use `devtools::test(filter = ...)` to run a subset — `testthat::test_file()` on
its own does not load the package and fails with "could not find function".

Equivalent checks from a shell, for a CI-like run or when working outside an R
session:

```sh
R CMD build . && R CMD check --as-cran clinPK_*.tar.gz
Rscript -e 'devtools::test()'
```

CI (`.github/workflows/R-CMD-check.yaml`) runs `R CMD check` with
`--no-manual --as-cran` on ubuntu-latest / R release, and fails on errors
(warnings and notes do not fail the build). A second workflow
(`.github/workflows/pkgdown.yaml`) builds the pkgdown site from `_pkgdown.yml`
with `pkgdown::build_site_github_pages()` on pushes to `master`.

### Documentation is generated

`man/*.Rd` and `NAMESPACE` are roxygen2 output — **never edit them by hand**.
Edit the roxygen comments above the function in `R/` and run
`devtools::document()`. Roxygen markdown is enabled
(`Roxygen: list(markdown = TRUE)`), so use markdown in doc comments.

Caveat: `DESCRIPTION` pins `RoxygenNote: 7.3.2`. If the locally installed
roxygen2 is newer, `document()` will rewrite that field (roxygen2 8.x replaces
it with `Config/roxygen2/version`) and may churn unrelated `.Rd` files. Check
`git diff` after documenting and keep the diff limited to the functions you
actually changed.

### Package data

`data-raw/` exists to preserve the origin story of the package data
(<https://r-pkgs.org/data.html#sec-data-data-raw>): the script there records
where each data set came from and how it was derived, so the `.rda` files are
reproducible rather than opaque.

Here, the CDC growth-chart data sets in `data/*.rda` are built by
`data-raw/growth-charts.R` from CSVs in `data-raw/data/`, with the source URL
recorded at the top of that script. Regenerate the `.rda` files through the
script rather than editing them, and update the script (not just the data) when
the source changes. `data-raw/` is excluded from the built package via
`.Rbuildignore`.

## Architecture

### File layout

`R/` is flat and mostly one exported function per file, named after the
function. Prefix conventions:

- `calc_*` — derived clinical quantities (eGFR, BSA, BMI, IBW/LBW/FFM/ABW,
  creatinine, AKI stage, half-life, elimination rate from TDM samples).
- `pk_1cmt_*` / `pk_2cmt_*` — analytical one- and two-compartment solutions.
  The suffix encodes the scenario: `_bolus` / `_inf` / `_oral` for the input,
  `_ss` for steady state, `_cmax_ss` / `_cmin_ss` for peak/trough, and
  `_dose_from_cmax` / `_dose_from_cmin` for the inverse (dose-finding) form.
- `convert_*`, `conc2mol` / `mol2conc`, `weight2kg`, `metric_conversion` —
  unit handling.
- `pct_*_for_*` / `median_*_for_*` — growth percentiles, all delegating to the
  internal generic `pct_growth_generic()` in `R/pct_growth_generic.R`.
- `nca*` — non-compartmental analysis; `nca()` returns an object of class
  `nca_output` with an S3 `print` method in `R/print.nca_output.R`.
- `utils.R` — unexported helpers shared across the package.

### The method-dispatch pattern

This is the most important pattern to follow. A multi-method function such as
`calc_lbw()`, `calc_ffm()`, or `calc_egfr()` is split into a validating
wrapper plus small, pure, unexported equation functions named
`<quantity>_<method>` (e.g. `lbw_green()`, `lbw_boer()`, `egfr_ckd_epi()`):

```r
calc_lbw <- function(weight = NULL, bmi = NULL, sex = NULL, height = NULL,
                     method = c("green", "boer", "james", "hume"), digits = 1) {
  check_input_lengths(sex = sex, weight = weight, height = height, bmi = bmi)
  method <- match.arg(method)
  method_fn <- switch(method, "green" = lbw_green, "boer" = lbw_boer, ...)

  inputs <- prepare_method_inputs(method_fn, method,
    weight = weight, bmi = bmi, sex = sex, height = height)

  inputs$sex <- normalize_sex(inputs$sex)
  if (is.null(inputs$sex)) return(NULL)

  lbw <- do.call(method_fn, inputs[intersect(names(inputs), formalArgs(method_fn))])
  list(value = round(lbw, digits), unit = "kg")
}
```

As a general rule, input validation, unit conversion, rounding and output
shaping live in the wrapper, and the inner functions take only the covariates
they need and are written so they vectorize.

The exception is method-specific applicability checks, which may stay in the
inner function because only that method knows its own validity range — see
`ffm_bucaloiu()`, which warns when the patient is not an obese female, and
`egfr_bedside_schwartz()`, which warns below age 1 and therefore also takes
`verbose`. Leave such checks where they are; do not hoist them into the wrapper
as a drive-by change.

Where every method is a one-line expression, the `switch()` holds the
expressions directly instead of function references — see `calc_bsa()`. Use
that lighter form only when no method needs its own covariate set or
validation.

`calc_ibw()` predates this pattern and does not follow it: it takes separate
`method_children` / `method_adults` arguments, its `ibw_standard()` and
`ibw_devine()` helpers validate their own inputs and warn, and the wrapper
returns a bare numeric vector. Treat it as a legacy exception rather than
refactoring it to match the pattern as a drive-by change.

Helpers in `R/utils.R` that make this work:

- `check_input_lengths(...)` — errors if vector arguments of length > 1 have
  inconsistent lengths, so recycling cannot silently produce wrong results.
- `prepare_method_inputs(fn, method, ...)` — inspects `formals(fn)` to find
  arguments without defaults, auto-computes `bmi` from `height` and `weight`
  when the method needs it, and errors listing exactly which covariates the
  chosen method requires.
- `normalize_sex(sex)` — lowercases and validates `"male"` / `"female"`;
  returns `NULL` after a warning so the caller can `return(NULL)`.
- `is.nil(x)` — the package's missing-value test (`NULL`, length 0, `NA`,
  `NaN`, or `""`).
- `%>=%` / `%<=%` — comparisons tolerant of floating-point error.

`calc_egfr()` additionally uses `egfr_cov_reqs()` (canonicalizes the method
name, including legacy misspellings such as `cockroft`, and returns the
required covariates) together with `check_covs_available()`.

### Vectorization

Functions are expected to work over vectors of patients. Inside equation
functions use `ifelse()` rather than `if`/`else` when branching on a covariate
such as `sex`, and prefer `vapply()` over `sapply()` for type stability. When
adding a method, add a test that exercises it with vector inputs mixing e.g.
both sexes — there are existing examples of exactly this in
`tests/testthat/test_calc_ffm.R`.

### Return-value conventions

There is no single package-wide contract. Preserve whatever the function you
are editing already returns — the shape is part of the public API.

- At least `value` and `unit`, with a `digits` argument that rounds `value`:
  `calc_lbw()`, `calc_ffm()`, `calc_creat()`, `calc_creat_neo()`. `calc_ffm()`
  and `calc_creat()` additionally return `method` (the resolved, lower-cased
  method name) — keep that field when editing them.
- `value` and `unit` only, no `digits`: `calc_bsa()`.
- Bare numeric, no `digits`: `calc_bmi()`, `calc_abw()`, `calc_ibw()`, and the
  `metric_conversion.R` helpers (`cm2inch()`, `lbs2kg()`, ...).
- `calc_egfr()` returns a wider list: `value` and `unit`, the covariates it
  resolved (`age`, `bsa`, `sex`, `scr`, `weight`), and `capped` — cap metadata
  (`min_value`/`min_n`, `max_value`/`max_n`), not a covariate, empty when
  `min_value`/`max_value` were not applied.
- Simulation functions (`pk_1cmt_inf()` and friends) return a `data.frame` of
  concentrations over time, optionally with residual error added by
  `add_ruv()`.

eGFR results also carry a `relative` notion (per 1.73 m²) converted via
`absolute2relative_bsa()` / `relative2absolute_bsa()`. Cockcroft-Gault and
derivatives default to absolute; other methods default to relative. Many
functions take `verbose` to control informational messages; keep new messages
behind it.

### Unit conversion

Not uniform either. Use the registry or table the function you are changing
already uses:

- `convert_creat_unit()`, `convert_albumin_unit()`, `convert_bilirubin_unit()`
  take `unit_in` / `unit_out` defaulted from `valid_units()`
  (`R/valid_units.R`) and delegate to `convert_conc_unit()` with a molecular
  weight (creatinine passes 113.12).
- `convert_conc_unit(value, unit_in, unit_out, mol_weight)` returns
  `list(value =, unit =)` using its own `conv` factor table, which is separate
  from `valid_units()`.
- `conc2mol()` / `mol2conc()` take `unit_conc` / `unit_mol`, hold their own
  inline unit vectors, and return `list(value =, unit =)`.
- `convert_flow_unit(value, from, to, weight)` and `weight2kg(value, unit)`
  return bare numerics; of the two only `weight2kg()` checks `valid_units()`.

Adding a unit spelling for the three wrapper functions above means editing two
places: `valid_units()` (or `match.arg()` rejects it) **and** the `conv` table
in `convert_conc_unit()` (or the delegate rejects it with "Unrecognized unit").
Keep the two in sync.

### Adding a new equation or method

1. Add the inner `<quantity>_<method>()` function in the relevant `R/` file
   (or a new file named after the exported function).
2. Wire it into the wrapper's `match.arg()` choices and `switch()`.
3. Cite the publication in the roxygen `References:` block — every equation in
   this package is tied to a peer-reviewed source, and reviewers expect the
   citation.
4. Add tests with values taken from the paper or an independent
   implementation, plus a vectorized case.
5. Run `devtools::document()`.
6. Add a bullet to the development-version section at the top of `NEWS.md`.

## Testing

testthat edition 3, tests in `tests/testthat/`. Name new test files
`test_<topic>.R` with an underscore: that is this repo's historic convention and
the large majority of existing files. Note that `usethis::use_test()` creates
`test-<topic>.R` with a hyphen, so rename the file after using it. Both
spellings currently occur, and `devtools::test(filter = )` matches either.

Tests assert on numeric results of published equations, typically as
`round(f(...)$value)` compared against the value in the source paper, so
expected numbers should be traceable to a reference and not simply snapshotted
from current output.

## Conventions

- Two-space indent, `<-` for assignment, `snake_case` names.
- Commit messages are short, lowercase, imperative, and backtick function
  names, e.g. ``refactor `calc_lbw()`, `calc_ffm()`, and `calc_egfr()` to
  reduce code duplication``. Work happens on branches (often `RXR-####`)
  merged into `master` by pull request.
- Backwards compatibility matters: this package is on CRAN and is consumed by
  downstream clinical software. Prefer deprecating an argument (as was done
  for `return_median` in the `pct_*_for_*()` functions) over removing it, and
  keep legacy method-name aliases working.
- `cran-comments.md` and `CRAN-SUBMISSION` support CRAN releases; the package
  targets roughly one CRAN release per year.

## Domain notes

Getting a coefficient wrong here produces a plausible-looking number that is
clinically wrong, and the package computes drug doses. Verify equations
against the cited publication rather than against intuition or another
implementation, keep unit handling explicit at every boundary, and do not
"simplify" an equation in a way that changes its numerical result.
