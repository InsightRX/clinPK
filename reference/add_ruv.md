# Add residual variability to data

Add residual variability to data

## Usage

``` r
add_ruv(x, ruv = list())
```

## Arguments

- x:

  data

- ruv:

  list with arguments prop, add, exp

## Examples

``` r
y <- pk_1cmt_inf()$y
y + add_ruv(y, list(prop = 0.1, add = 0.05))
#> numeric(0)
```
