# Calculate dose based on a given AUC24, Cmax, and Cmin, assuming 1-compartment model

Calculate dose based on a given AUC24, Cmax, and Cmin, assuming
1-compartment model

## Usage

``` r
pk_1cmt_inf_dose_for_range(
  target = 500,
  type = "auc",
  conc_range = c(10, 40),
  parameters = list(),
  interval = 24,
  t_inf = 1,
  optimize_interval = TRUE,
  round_interval = TRUE
)
```

## Arguments

- target:

  numeric value of target

- type:

  target type, one of `auc`, `auc24`, `ctrough`, `cmin`

- conc_range:

  concentration range to stay within, vector of length 2

- parameters:

  list of `CL` and `V`, or `KEL` and `CL`

- interval:

  dosing interval

- t_inf:

  infusion time

- optimize_interval:

  find optimal interval (to stay within `conc_range`?

- round_interval:

  round interval to nearest nominal interval?
