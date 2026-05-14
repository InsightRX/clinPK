# Calculate Cefepime-associated Neurotoxicity

Calculate probability of cefepime-associated neurotoxicity as a function
of cefepime plasma trough concentrations. This model was based on a data
set of adult patients receiving thrice-daily cefepime and may not
correspond to other dosing intervals or patient populations.

## Usage

``` r
calc_cefepime_neurotoxicity(trough_concentration)
```

## Arguments

- trough_concentration:

  Cefepime plasma trough concentration (mg/L).

## Value

Probability of cefepime-associated neurotoxicity.

## Note

The intercept and slope used in this function match Figure 2 in the
cited paper, but differ slightly from the values provided in the text.
This interpretation was confirmed via correspondence with the authors.

## References

[Boschung-Pasquier et al., Clinical Microbiology and Infection
(2020)](https://doi.org/10.1016/j.cmi.2019.06.028)

## Examples

``` r
calc_cefepime_neurotoxicity(trough_concentration = c(13.7, 17.8))
#> [1] 0.2498005 0.5002675
```
