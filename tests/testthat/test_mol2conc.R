test_that("Mol --> conc", {
  expect_equal(
    mol2conc(
      mol = 1,
      mol_weight = 100,
      unit_conc = "g/L",
      unit_mol = "mol/L"
    )$value,
    100
  )
})
