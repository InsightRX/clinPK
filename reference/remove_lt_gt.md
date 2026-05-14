# Remove less-than/greater-than symbols and convert to numeric

The following characters will be removed from strings: \<, \>, =, space.
If string contains other characters, the original string will be
returned.

## Usage

``` r
remove_lt_gt(x)
```

## Arguments

- x:

  Vector of numbers possibly containing extraneous strings.

## Value

If non-numeric characters were successfully removed, returns a numeric
vector. If some elements of `x` contained other characters, their
original value will be returned and the result will be a character
vector.
