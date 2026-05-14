# Calculate fat-free mass

Get an estimate of fat-free mass (FFM, in kg) based on weight, height,
and sex (and age for Storset equation).

## Usage

``` r
calc_ffm(
  weight = NULL,
  bmi = NULL,
  sex = NULL,
  height = NULL,
  age = NULL,
  method = c("janmahasatian", "green", "al-sallami", "storset", "bucaloiu", "hume",
    "james", "garrow_webster"),
  digits = 1
)
```

## Arguments

- weight:

  total body weight in kg

- bmi:

  BMI, only used in `green` method. If `weight` and `height` are both
  specified, `bmi` will be calculated on-the-fly.

- sex:

  sex, either `male` of `female`

- height:

  height in cm, only required for `holford` method, can be used instead
  of `bmi` for `green` method

- age:

  age, only used for Storset equation

- method:

  estimation method, one of `janmahasatian` (default), `green`,
  `al-sallami`, `storset`, `bucaloiu`, `hume`, `james`, or
  `garrow_webster`.

- digits:

  round to number of digits

## Value

Returns a list of the following elements:

- value:

  Fat-free Mass (FFM) in units of kg

- unit:

  Unit describing FFM, (kg)

- method:

  Method used to calculate FFF

## Details

References: `janmahasatian`, `green`: Janmahasatian et al. Clin
Pharmacokinet. 2005;44(10):1051-65) `al-sallami`: Al-Sallami et al. Clin
Pharmacokinet 2015 `storset`: Storset E et al. TDM 2016 `bucaloiu`:
Bucaloiu ID et al. Int J of Nephrol Renovascular Dis. 2011 (Morbidly
obese females) `hume`: Hume R. J Clin Pathol 1966 `james`: James WPT et
al. Research on obesity: a report of the DHSS/MRC Group 1976
`garrow_webster`: Garrow JS, Webster J. Quetelet's index (W/H2) as a
measure of fatness. Int J Obesity 1984

Overview:

- Sinha J, Duffull1 SB, Al-Sallami HS. Clin Pharmacokinet 2018.
  https://doi.org/10.1007/s40262-017-0622-5

## Examples

``` r
calc_ffm(weight = 70, bmi = 25, sex = "male")
#> $value
#> [1] 53.7
#> 
#> $unit
#> [1] "kg"
#> 
#> $method
#> [1] "janmahasatian"
#> 
calc_ffm(weight = 70, height = 180, age = 40, sex = "female", method = "storset")
#> $value
#> [1] 47.5
#> 
#> $unit
#> [1] "kg"
#> 
#> $method
#> [1] "storset"
#> 
```
