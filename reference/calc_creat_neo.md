# Estimate serum creatinine in neonates

Calculate an estimated serum creatinine. Function takes vectorized input
as well.

## Usage

``` r
calc_creat_neo(pma = NULL, digits = 1)
```

## Arguments

- pma:

  post-natal age in weeks

- digits:

  number of digits to round to

## Details

Uses equations described in Germovsek E et al.
(http://www.ncbi.nlm.nih.gov/pubmed/27270281) based on data from
Cuzzolin et al. (http://www.ncbi.nlm.nih.gov/pubmed/16773403) and Rudd
et al. (http://www.ncbi.nlm.nih.gov/pubmed/6838252)

## Examples

``` r
cr <- calc_creat_neo(pma = 36)
convert_creat_unit(cr$value, unit_in = cr$unit, unit_out = "mg/dL")
#> $value
#> [1] 0.7228368
#> 
#> $unit
#> [1] "mg/dl"
#> 
```
