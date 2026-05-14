# Calculate neutropenia grade from ANC

Assigns neutropenia grade based on the National Cancer Institute system.
Note that while this system assigns a grade of 1 to an ANC between
1500-2000, the term neutropenia is usually reserved for a grade of 2 or
higher (an ANC of \<1500)

## Usage

``` r
calc_neutropenia_grade(anc)
```

## Arguments

- anc:

  absolute neutrophil count (ANC), in number per microliter

## References

- [Neutropenia](https://link.springer.com/referenceworkentry/10.1007/978-3-642-16483-5_4052):
  US National Cancer Institute's Common Toxicity Criteria

## Examples

``` r
calc_neutropenia_grade(
  anc = c(500, 1501)
)
#> [1] 3 1
```
