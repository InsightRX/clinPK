# Convert concentration units

Lower-level function called by
[`convert_creat_unit()`](https://insightrx.github.io/clinPK/reference/convert_creat_unit.md),
[`convert_albumin_unit()`](https://insightrx.github.io/clinPK/reference/convert_albumin_unit.md),
and others.

## Usage

``` r
convert_conc_unit(value, unit_in, unit_out, mol_weight = NULL)
```

## Arguments

- value:

  Value to convert

- unit_in:

  Input unit

- unit_out:

  Output unit

- mol_weight:

  Molecular weight in g/mol (required if converting to/from molar units)

## See also

valid_units
