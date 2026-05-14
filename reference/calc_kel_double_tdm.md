# Calculate elimination rate when given two TDM samples

Calculate elimination rate when given two TDM samples

## Usage

``` r
calc_kel_double_tdm(
  dose = 1000,
  t = c(2, 11.5),
  dv = c(30, 10),
  tau = 12,
  t_inf = 1,
  V = NULL,
  steady_state = TRUE,
  return_parameters = FALSE
)
```

## Arguments

- dose:

  dose amount

- t:

  time or time after dose, vector of size 2

- dv:

  observed value, vector of size 2

- tau:

  dosing interval

- t_inf:

  infusion time

- V:

  if specified, use that (empiric) value and don't estimate from data.
  Default `NULL`.

- steady_state:

  samples taken at steady state? Only influences AUCtau.

- return_parameters:

  return all parameters instead of only kel?

## Examples

``` r
calc_kel_double_tdm(dose = 1000, t = c(3, 18), dv = c(30, 10))
#> [1] 0.07324082
```
