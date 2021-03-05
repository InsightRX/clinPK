library(clinPK)
library(testit)

## Error cases
assert("wrong unit specified", has_error(convert_flow_unit(70, "kg/hr", "L/hr", weight = 50)))
assert("wrong unit specified", has_error(convert_flow_unit(70, "L/hr", "kg", weight = 50)))

## basic conversions
assert("correct conversion", convert_flow_unit(60, "L/hr", "ml/min") == 1000)
assert("correct conversion", convert_flow_unit(1, "L/min", "ml/min") == 1000)
assert("correct conversion", convert_flow_unit(60, "mL/hr", "ml/min") == 1)
assert("correct conversion", convert_flow_unit(10, "ml/MIN", "l/HR") == 0.6)

## to/from day
assert("correct conversion", convert_flow_unit(10, "L/hr", "L/day") == 240)
assert("correct conversion", convert_flow_unit(240, "L/day", "L/hr") == 10)

## weight-based conversion
assert("correct conversion", convert_flow_unit(100, "L/hr", "L/hr/kg", weight = 50) == 2)
assert("correct conversion", convert_flow_unit(2, "L/hr/kg", "L/hr", weight = 50) == 100)
assert("correct conversion", convert_flow_unit(600, "L/hr", "ml/min/kg", weight = 50) == 200)
assert("correct conversion", convert_flow_unit(1, "mL/min/kg", "L/hr", weight = 50) == 3)

## Vector input
assert("correct conversion", all(round(convert_flow_unit(c(10, 20, 30), "L/hr", "ml/min"), 2) == c(166.67, 333.33, 500)))
assert("correct conversion", all(round(convert_flow_unit(c(10, 20, 30), c("L/hr", "mL/min", "L/hr"), "ml/min"),2) == c(166.67, 20, 500)))
assert("correct conversion", all(round(convert_flow_unit(c(10, 20, 30), "L/hr", "ml/min"), 2) == c(166.67, 333.33, 500)))
assert("correct conversion", all(round(convert_flow_unit(c(10, 20, 30), 
                  c("L/hr", "mL/min", "L/hr"), 
                  c("ml/min", "L/hr", "L/hr/kg"), weight=70), 2) == c(166.67, 1.2, 0.43)))
assert("correct conversion", all(round(convert_flow_unit(c(10, 20, 30), 
                  c("L/hr", "mL/min", "L/hr"), 
                  c("ml/min/kg", "L/hr", "L/hr/kg"), weight=c(70, 80, 90)), 2) == c(2.38, 1.2, 0.33)))
