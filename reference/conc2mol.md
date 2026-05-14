# Convert concentration to molar

Convert concentration to molar

## Usage

``` r
conc2mol(conc = NULL, unit_conc = NULL, mol_weight = NULL, unit_mol = NULL)
```

## Arguments

- conc:

  concentration in e.g. g/L

- unit_conc, :

  one of `g/l`, `mg/l`, `microg/l`,
  `mcg/l", `ng/l`, `mg/ml`, `microg/ml`, `mcg/ml`, `ng/ml\`

- mol_weight:

  concentration in g/mol

- unit_mol:

  one of `mol/L`, `mmol/mL`, `mmol/L`

## Examples

``` r
conc2mol(100, unit_conc = "g/l", mol_weight = 180.15588)
#> Molar unit not specified, assuming mol/L.
#> $value
#> [1] 0.5550749
#> 
#> $unit
#> [1] "mol/L"
#> 
```
