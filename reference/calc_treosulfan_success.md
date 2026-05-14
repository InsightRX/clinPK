# Calculate probability of therapeutic success for treosulfan

Calculate probability of therapeutic success for treosulfan as a
function of cumulative AUC. This model was based on a data set of
children receiving treosulfan once daily for 3 days and may not
correspond to other dosing intervals or patient populations.

## Usage

``` r
calc_treosulfan_success(cumulative_auc)
```

## Arguments

- cumulative_auc:

  Cumulative AUC mg hour/L.

## Value

Probability of therapeutic success for treosulfan.

## Note

The parameter estimates used in this function match Figure 3a in the
cited paper, but differ slightly from the values provided in Table 2,
which were rounded. The decimal values used here were solved for using
results cited in the paper, and are close but not an exact match.

## References

[Chiesa et al., Clinical Pharmacology and Therapeutics
(2020)](https://doi.org/10.1002/cpt.1715)

## Examples

``` r
calc_treosulfan_success(c(3863, 4800, 4829, 6037))
#> [1] 0.7864854 0.8171991 0.8172208 0.7864636

curve(
  calc_treosulfan_success,
  from = 2000, 
  to = 15000, 
  log = "x", 
  ylim = c(0, 1),
  xlab = "Cumulative AUC",
  ylab = "P(Success)"
)
```
