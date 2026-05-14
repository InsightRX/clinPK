# Calvert equation for carboplatin

The Calvert equation calculates a dose expected to bring the patient to
the target AUC given their glomerular filtration rate (GFR). The
original equation was developed on a data set of 18 individuals with GFR
of 33-136 ml/min.

## Usage

``` r
calc_carboplatin_calvert(target_auc, gfr = NULL, ...)
```

## Arguments

- target_auc:

  target AUC, in mg/ml-min, typically between 2-8 mg/ml-min

- gfr:

  glomerular filtration rate, in ml/min. See also
  [`clinPK::calc_egfr`](https://insightrx.github.io/clinPK/reference/calc_egfr.md).

- ...:

  arguments passed on to `calc_egfr` if gfr is not supplied

## References

[Calvert et al., Journal of Clinical Oncology
(1976)](https://ascopubs.org/doi/abs/10.1200/JCO.1989.7.11.1748)

## Examples

``` r
calc_carboplatin_calvert(5, 100)
#> [1] 700
calc_carboplatin_calvert(4, 30)
#> [1] 224
calc_carboplatin_calvert(2, sex = "male", age = 50, scr = 1.1, weight = 70)
#> Creatinine unit not specified, assuming mg/dL.
#> [1] 230.9091
```
