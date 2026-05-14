# Calculate AKI stage according to KDIGO criteria

Calculate AKI stage according to KDIGO criteria

## Usage

``` r
kdigo_stage(dat, baseline_scr, age)
```

## Arguments

- dat:

  Data frame containing at least the following columns:

  - `scr`: serum creatinine

  - `t`: creatinine sample times in hours

  - `baseline_scr_diff`: difference between baseline scr and scr at
    current timepoint

  - `egfr`: eGFR at timepoint

- baseline_scr:

  Baseline serum creatinine value (numeric)

- age:

  Patient age
