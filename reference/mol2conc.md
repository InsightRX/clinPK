# Convert molar to concentration

Convert molar to concentration

## Usage

``` r
mol2conc(mol = NULL, unit_mol = NULL, unit_conc = NULL, mol_weight = NULL)
```

## Arguments

- mol:

  concentration in molars

- unit_mol:

  unit of input concentration (molar), one of `mol/L`, `mmol/mL`,
  `mmol/L`

- unit_conc, :

  output unit, one of `g/l`, `mg/l`, `microg/l`,
  `mcg/l", `ng/l`, `mg/ml`, `microg/ml`, `mcg/ml`, `ng/ml\`

- mol_weight:

  concentration in g/mol

## Examples

``` r
mol2conc(1, unit_mol = "mmol/l", mol_weight = 180)
#> Output concentration unit not specified, assuming mg/L.
#> $value
#> [1] 180
#> 
#> $unit
#> [1] "mg/l"
#> 
```
