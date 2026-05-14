# Perform an NCA based on a NONMEM-style dataset

Perform an NCA based on a NONMEM-style dataset

## Usage

``` r
nca(
  data = NULL,
  dose = 100,
  tau = 24,
  method = c("log_linear", "log_log", "linear"),
  scale = list(auc = 1, conc = 1),
  dv_min = 0.001,
  t_inf = NULL,
  fit_samples = NULL,
  weights = NULL,
  extend = TRUE,
  has_baseline = TRUE,
  route = c("iv", "oral", "im", "sc")
)
```

## Arguments

- data:

  data.frame with time and dv columns

- dose:

  dose amount

- tau:

  dosing frequency, default is 24.

- method:

  `linear`, `log_linear` (default), or `log_log`

- scale:

  list with scaling for auc and concentration (`conc`)

- dv_min:

  minimum concentrations, lower observations will be set to this value

- t_inf:

  infusion time, defaults to 0

- fit_samples:

  vector of sample indexes used in fit to calculate elimination rate,
  e.g. `c(3,4,5)`. If not specified (default), it will evaluate which of
  the last n samples shows the largest adjusted R^2 when log-transformed
  data is fitted using linear regression, and use those samples in the
  estimation of the elimination rate.

- weights:

  vector of weights to be used in linear regression (same size as
  specified concentration data), or function with concentration as
  argument.

- extend:

  perform an 'extended' NCA, i.e. for the calculation of the AUCs,
  back-extend to the expected true Cmax to also include that area.

- has_baseline:

  does the included data include a baseline? If `FALSE`, baseline is set
  to zero.

- route:

  administration route, `iv` (intravenous, default), `oral`, `sc`
  (sub-cutaneous), or `im` (intra-muscular).

## Value

Returns a list of three lists:

- `pk`:

  Lists pk parameters.

  - `kel`: elimination constant

  - `t_12`: half-life

  - `v`: distribution volume

  - `cl`: clearance

- `descriptive`:

  Lists exposure parameters.

  - `cav_t`: the average concentration between the first observation and
    the last observation without extrapolating to tau

  - `cav_tau`: the average concentration from 0 to tau

  - `cmin`: the extrapolated concentration at `time = tau`

  - `c_max_true`: only available if `extend = TRUE`, the extrapolated
    peak concentration

  - `c_max`: only available if `extend = FALSE`, the observed maximum
    concentration

  - `auc_inf`: the extrapolated AUC as time goes to infinity

  - `auc_24`: the extrapolated AUC after 24 hours, provided no further
    doses are administered

  - `auc_tau`: the extrapolated AUC at the end of the dosing interval

  - `auc_t`: the AUC at the time of the last observation

- `settings`:

  Lists dosing information.

  - `dose`: dose quantity

  - `tau`: dosing interval

## Examples

``` r
data <- data.frame(time = c(0, 2, 4, 6, 8, 12, 16),
                   dv   = c(0, 10, 14, 11, 9, 5, 1.5))
nca(data, t_inf = 2)
#>               value
#> kel          0.1807
#> t_12         3.8358
#> v            4.1763
#> cl           0.7547
#> tmax         4.0000
#> cav_t        8.2119
#> cav_tau      5.7390
#> c_min        0.3534
#> c_max_true  20.0949
#> auc_inf    139.6910
#> auc_24     137.7354
#> auc_tau    137.7354
#> auc_t      131.3902
#> auc_pre     14.0000
```
