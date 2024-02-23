## R CMD check results

0 errors | 0 warnings | 1 note

❯ checking CRAN incoming feasibility ... [5s/30s] NOTE
  Maintainer: ‘Ron Keizer <ron@insight-rx.com>’
  
  New maintainer:
    Ron Keizer <ron@insight-rx.com>
  Old maintainer(s):
    Kara Woo <kara@insight-rx.com>
    
  Found the following (possibly) invalid URLs:
  URL: https://ascopubs.org/doi/abs/10.1200/JCO.1989.7.11.1748
    From: man/calc_carboplatin_calvert.Rd
    Status: 403
    Message: Forbidden
  URL: https://www.nejm.org/doi/10.1056/NEJMms2004740
    From: man/calc_egfr.Rd
    Status: 403
    Message: Forbidden
  URL: https://www.nejm.org/doi/full/10.1056/NEJMoa2102953
    From: man/calc_egfr.Rd
    Status: 403
    Message: Forbidden
  URL: https://www.thelancet.com/journals/lanonc/article/PIIS1470-2045(21)00377-6/fulltext
    From: man/calc_egfr.Rd
    Status: 403
    Message: Forbidden

## Maintainer notes

This release involves a change in maintainer from Kara Woo to Ron Keizer.

The four URLs that show 403 responses are valid and correct, but may forbid requests with curl in the User-Agent header.
