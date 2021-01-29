library(clinPK)
library(testit)

## NCA
data <- data.frame(cbind(time = c(0, 1, 2, 4, 6, 8),
                         dv   = c(300, 1400, 1150, 900, 700, 400)))
t1 <- nca(data, has_baseline = TRUE, tau = 12, t_inf = 0.5, extend = FALSE)
assert("NCA estimates are correct (AUCinf)", round(t1$descriptive$auc_inf) == 8049)
assert("NCA estimates are correct (AUCtau)", round(t1$descriptive$auc_tau) == 6824)
assert("NCA estimates are correct (AUCt)", round(t1$descriptive$auc_t) == 6824)
assert("NCA estimates are correct (css_t)", round(t1$descriptive$cav_t) == 853)
assert("NCA estimates are correct (css_tau)", round(t1$descriptive$cav_tau) == 569)

t1a <- nca(data, has_baseline = TRUE, tau = 12, t_inf = 0.5, extend = TRUE)
assert("NCA estimates are correct (AUCinf)", round(t1a$descriptive$auc_tau) == 8721)

## NCA with weighting function
t1b <- nca(data, has_baseline = TRUE, tau = 12, t_inf = 0.5, extend = TRUE, weights = function(y) { 1/sqrt(y) } )
assert("NCA estimates half life different", round(t1b$pk$t_12,2) == 4.03)

## NCA with adaptive n samples
t1c <- nca(data, has_baseline = TRUE, tau = 12, t_inf = 0.5, extend = TRUE )
assert("Uses last 5 samples", t1c$settings$last_n == 5)

## NCA with missing data
data <- data.frame(cbind(time = c(0, 1, 2, 4, 6, 8),
                         dv   = c(300, 1400, NA, 900, NA, 400)))
t2 <- nca(data, has_baseline = TRUE, tau = 12, extend = TRUE, t_inf = 0)
assert("NCA estimates are correct (AUCinf)", round(t2$descriptive$auc_inf) == 10464)
assert("NCA estimates are correct (AUCt)", round(t2$descriptive$auc_t) == 8245)
assert("NCA estimates are correct (css_t)", round(t2$descriptive$cav_t) == 1031)
assert("NCA estimates are correct (css_tau)", round(t2$descriptive$cav_tau) == 782)

## NCA with same DV at 2 different timepoints:
dat1 <- data.frame(time = c(0, 0.5, 1, 2.5, 4), dv = c(0, 10, 5, 5, 1))
dat2 <- data.frame(time = c(0, 0.5, 1, 2.5, 4), dv = c(0, 10, 5.001, 5, 1))
res1 <- nca(dat1, t_inf = 0.5)
res2 <- nca(dat2, t_inf = 0.5)
assert("output nearly similar to case in limit", (abs(res1$descriptive$auc_24 - res2$descriptive$auc_24)/ res1$descriptive$auc_24) < 0.0001)

## NCA with same DV at 3 different timepoints:
dat3 <- data.frame(time = c(0, 0.5, 1, 2.5, 4, 8), dv = c(0, 10, 5, 5, 5, 1))
dat4 <- data.frame(time = c(0, 0.5, 1, 2.5, 4, 8), dv = c(0, 10, 5.001, 5, 4.999, 1))
res3 <- nca(dat3, t_inf = 0.5)
res4 <- nca(dat4, t_inf = 0.5)
assert("output nearly similar to case in limit", (abs(res3$descriptive$auc_24 - res4$descriptive$auc_24)/ res3$descriptive$auc_24) < 0.0001)
