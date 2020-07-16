# Test function to calculate dose from 1cmt PK
library(clinPK)
library(testit)

dos1 <- pk_1cmt_inf_dose_for_range(target = 400, type = "auc",
                                   conc_range = c(40, 10),
                                   parameters = list(CL = 5, V = 50),
                                   interval = 12, t_inf = 1,
                                   optimize_interval = TRUE,
                                   round_interval = TRUE)

dos2 <- pk_1cmt_inf_dose_for_range(target = 15, type = "cmin",
                                   conc_range = c(40, 10),
                                   parameters = list(CL = 5, V = 50),
                                   interval = 12, t_inf = 1,
                                   optimize_interval = FALSE,
                                   round_interval = TRUE)

dos3 <- pk_1cmt_inf_dose_for_range(target = 15, type = "cmin",
                                   conc_range = c(40, 10),
                                   parameters = list(CL = 5, V = 50),
                                   interval = 8, t_inf = 1,
                                   optimize_interval = FALSE,
                                   round_interval = TRUE)

assert("Errors on unknown target type",
       has_error(pk_1cmt_inf_dose_for_range(target = 15, type = "blabla",
                                   conc_range = c(40, 10),
                                   parameters = list(CL = 5, V = 50),
                                   interval = 8, t_inf = 1,
                                   optimize_interval = FALSE,
                                   round_interval = TRUE)))

assert("AUC opt works", round(dos1$dose,1) == 1000)
assert("AUC opt works", dos1$interval == 12)

assert("Cmin opt works", round(dos2$dose,1) == 1654.5)
assert("Cmin opt works", dos2$interval == 12)
assert("Cmin opt works, shorter interval", round(dos3$dose,1) == 874.0)
assert("Cmin opt works", dos3$interval == 8)

