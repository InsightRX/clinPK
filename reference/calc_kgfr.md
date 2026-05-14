# Calculate kinetic GFR

Calculate the kinetic GFR based on a patients first two serum creatinine
measurements. Kinetic GFR may be more predictive of future AKI for
patients whose serum creatinine is changing quickly. Briefly, an
increase in SCr over the course of a day indicates an effective GFR
lower than the most recent SCr measurement may indicate if steadystate
is assumed, while a decrease in SCr over a short time indicates a higher
effective GFR than the most recent SCr would indicate. There are several
ways of approximating maximum theoretical creatinine accumulation rate;
here the method used by Pianta et al., (PLoS ONE, 2015) has been
implemented.

## Usage

``` r
calc_kgfr(
  scr1 = NULL,
  scr2 = NULL,
  scr_unit = "mg/dl",
  time_delay = NULL,
  weight = NULL,
  vd = NULL,
  egfr = NULL,
  egfr_method = NULL,
  sex = NULL,
  age = NULL,
  height = NULL,
  ...
)
```

## Arguments

- scr1:

  baseline scr

- scr2:

  second scr measurement

- scr_unit:

  scr unit, defaults to mg/dl

- time_delay:

  time between scr1 and scr2 in hours

- weight:

  patient weight in kg

- vd:

  volume of distribution in L, defaults to 0.6 \* weight

- egfr:

  eGFR in ml/min at the time of scr1, or leave blank to call calc_egfr

- egfr_method:

  string, only necessary if egfr is not specified.

- sex:

  string (male or female), only necessary if egfr is not specified.

- age:

  age in years, only necessary if egfr is not specified.

- height:

  in m, necessary only for some egfr calculation methods.

- ...:

  further arguments (optional) to be passed to calc_egfr.

## Value

kGFR, in ml/min

## References

[Pianta et al., PLoS ONE
(2015)](https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0125669)

## Examples

``` r
calc_kgfr(weight = 100, scr1 = 150, scr2 = 200, scr_unit = 'umol/l',
         time_delay = 24, egfr = 30)
#> [1] 23.2
calc_kgfr(weight = 70, scr1 = 350, scr2 = 300, scr_unit = 'umol/l',
          time_delay = 24, egfr_method = 'mdrd', age = 70, sex = 'male')
#> [1] 27.73735
```
