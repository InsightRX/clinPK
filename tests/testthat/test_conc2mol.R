test_that("Conc --> mol", {
  expect_equal(
    conc2mol(
      conc = 1,
      mol_weight = 100,
      unit_conc = "g/L",
      unit_mol = "mol/L"
    )$value,
    0.01
  )
  expect_equal(
    conc2mol(
      conc = 1,
      mol_weight = 100,
      unit_conc = "mg/L",
      unit_mol = "mol/L"
    )$value,
    1e-5
  )
})
