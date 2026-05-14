# Estimate serum creatinine

Calculate an estimated serum creatinine. Function takes vectorized input
as well.

## Usage

``` r
calc_creat(
  sex = NULL,
  age = NULL,
  weight = NULL,
  height = NULL,
  adult_method = c("johanssen", "brooks"),
  digits = 1
)
```

## Arguments

- sex:

  sex, either `male` or `female`

- age:

  age in years

- weight:

  weight in kg (default 75 kg)

- height:

  height in cm (default 165 cm)

- adult_method:

  estimation adult method, `johanssen` (default) or `brooks`,

- digits:

  number of digits to round to

## Details

For children and adolescents: Uses equations described in Ceriotti et
al. Clin Chem. 2008, and Junge W et al. Clin Chim Acta. 2004. For age
15-18, a linear interpolation is used between equations for \<15
Johanssen A et al. Ther Drug Monit 2011. For adults: Two methods are
available Johanssen et al. Ther Drug Monit 2011. which describes a flat
serum creatinine dependent on sex, and Brooks et al (unpublished) which
is a linear regression built on the NHANES open-source data and takes
into account sex, age, weight, and height. Equation:
`lm(SCr~Age+Sex+Weight+Height, data=NHANES)`

## Examples

``` r
calc_creat(sex = "male", age = 40)
#> $value
#> [1] 84
#> 
#> $unit
#> [1] "micromol/L"
#> 
#> $method
#> [1] "johanssen"
#> 
calc_creat(sex = "male", age = 40, weight = 100, height = 175, adult_method = "brooks")
#> $value
#> [1] 84.9
#> 
#> $unit
#> [1] "micromol/L"
#> 
#> $method
#> [1] "brooks"
#> 
calc_creat(sex = "male", age = c(10, 17, 60))
#> $value
#> [1] 43.6 74.5 84.0
#> 
#> $unit
#> [1] "micromol/L"
#> 
#> $method
#> [1] "johanssen"
#> 
```
