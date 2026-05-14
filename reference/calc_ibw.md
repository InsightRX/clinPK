# Calculate ideal body weight in kg for children and adults

Get an estimate of ideal body weight. This function allows several
commonly used equations

## Usage

``` r
calc_ibw(
  weight = NULL,
  height = NULL,
  age = NULL,
  sex = "male",
  method_children = "standard",
  method_adults = "devine"
)

ibw_standard(age, height = NULL, sex = NULL)

ibw_devine(age, height = NULL, sex = NULL)
```

## Arguments

- weight:

  weight in kg

- height:

  height in cm

- age:

  age in years

- sex:

  sex

- method_children:

  method to use for children \>1 and \<18 years. Currently `"standard"`
  is the only method that is supported.

- method_adults:

  method to use for \>=18 years. Currently `"devine"` is the only method
  that is supported (Devine BJ. Drug Intell Clin Pharm. 1974;8:650-655).

## Details

Equations:

For \<1yo Use actual body weight

For 1-17 years old ('standard'): if height \< 5ft: IBW= (height in cm2 x
1.65)/1000 if height \> 5ft: IBW (male) = 39 + (2.27 x height in inches
over 5 feet) IBW (female) = 42.2 + (2.27 x height in inches over 5 feet)

Methods not implemented yet: McLaren: IBW = - step1: x = 50th percentile
height for given age - step2: IBW = 50th percentile weight for x on
weight-for-height scale Moore: IBW = weight at percentile x for given
age, where x is percentile of height for given age BMI: IBW = 50th
percentile of BMI for given age x (height in m)^2 ADA: IBW = 50th
percentile of WT for given age

For \>= 18 years old (Devine equation) IBW (male) = 50 + (2.3 x height
in inches over 5 feet) IBW (female) = 45.5 + (2.3 x height in inches
over 5 feet)

## Examples

``` r
calc_ibw(weight = 70, height = 170, age = 40, sex = "female")
#> [1] 61.43701
calc_ibw(weight = 30, height = 140, age = 10, sex = "female")
#> [1] 32.34
```
