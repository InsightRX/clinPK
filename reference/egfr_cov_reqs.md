# Returns parameters needed to calculate eGFR according to the method specified.

returns a named list, with the name being the eGFR method after being
checked for certain typos or misspecifications, and the values being the
required covariates.

## Usage

``` r
egfr_cov_reqs(method, relative = NULL)
```

## Arguments

- method:

  egfr calculation method

- relative:

  if egfr calculations should be relative or not

## Examples

``` r
egfr_cov_reqs('schwartz_revised')
#> $schwartz_revised
#> [1] "creat"  "age"    "sex"    "height"
#> 
```
