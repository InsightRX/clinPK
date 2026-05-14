# Convert serum creatinine from various assays to Jaffe

Based on equations as reported in Srivastava et al. 2009 (Pediatr Res.
2009 Jan;65(1):113-6. doi: 10.1203/PDR.0b013e318189a6e8)

## Usage

``` r
convert_creat_assay(scr, from = "idms", to = "jaffe")
```

## Arguments

- scr:

  vector of serum creatinine values

- from:

  assay type, either `jaffe`, `enzymatic` or `idms`

- to:

  assay type, either `jaffe`, `enzymatic` or `idms`

## Examples

``` r
convert_creat_assay(scr = c(1.1, 0.8, 0.7), from = "enzymatic", to = "jaffe")
#> [1] 1.1542857 0.8685714 0.7733333
```
