# Calculate elimination rate when given a single TDM sample

Using iterative k_el calculation, and based on given Volume

## Usage

``` r
calc_kel_single_tdm(
  dose = 1000,
  V = 50,
  t = 10,
  dv = 10,
  tau = 12,
  t_inf = 1,
  kel_init = 0.1,
  n_iter = 25,
  learn_rate = 0.2
)
```

## Arguments

- dose:

  dose amount

- V:

  volume of distribution

- t:

  time or time after dose

- dv:

  observed value

- tau:

  dosing interval

- t_inf:

  infusion time

- kel_init:

  estimate of elimination rate

- n_iter:

  number of iterations to improve estimate of elimination rate

- learn_rate:

  default is 0.2

## Examples

``` r
calc_kel_single_tdm(dose = 1000, t = 18)
#> [1] 0.1563328
```
