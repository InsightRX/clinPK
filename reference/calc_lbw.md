# Calculate lean body weight

Get an estimate of lean body weight (LBW, in kg) based on weight,
height, and sex.

## Usage

``` r
calc_lbw(
  weight = NULL,
  bmi = NULL,
  sex = NULL,
  height = NULL,
  method = "green",
  digits = 1
)
```

## Arguments

- weight:

  total body weight in kg

- bmi:

  bmi

- sex:

  sex, either `male` of `female`

- height:

  height in cm

- method:

  estimation method, either `green` (default), `boer`, `james`, `hume`

- digits:

  round to number of digits

## Value

Returns a list of the following elements:

- value:

  Lean Body Weight (LBW) in units of kg

- unit:

  Unit describing LBW, (kg)

## Details

Note: technically not the same as fat-free mass, although difference is
small.

References: `green`: Green and Duffull. Clin Pharmacol Ther 2002;
`james`: Absalom AR et al. Br J Anaesth 2009; 103:26-37. James W.
Research on obesity. London: Her Majesty's Stationary Office, 1976.
`hume` : Hume R et al. J Clin Pathol. 1966 Jul; 19(4):389-91. `boer` :
Boer P et al. Am J Physiol 1984; 247: F632-5

## Examples

``` r
calc_lbw(weight = 80, height = 170, sex = "male")
#> $value
#> [1] 59.7
#> 
#> $unit
#> [1] "kg"
#> 
calc_lbw(weight = 80, height = 170, sex = "male", method = "james")
#> $value
#> [1] 59.7
#> 
#> $unit
#> [1] "kg"
#> 
```
