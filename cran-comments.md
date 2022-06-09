## Test environments
- R-hub windows-x86_64-devel (r-devel)
- R-hub ubuntu-gcc-release (r-release)
- R-hub fedora-clang-devel (r-devel)
- Winbuilder (r-release)

## R CMD check results
❯ On windows-x86_64-devel (r-devel), ubuntu-gcc-release (r-release), fedora-clang-devel (r-devel)
  checking CRAN incoming feasibility ... NOTE
  Maintainer: 'Kara Woo <kara@insight-rx.com>'
  
  New maintainer:
    Kara Woo <kara@insight-rx.com>
  Old maintainer(s):
    Ron Keizer <ronkeizer@gmail.com>
  
  Found the following (possibly) invalid URLs:
    URL: https://academic.oup.com/clinchem/article/53/4/766/5627682
      From: man/calc_egfr.Rd
      Status: 403
      Message: Forbidden
    URL: https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2763564/
      From: man/calc_egfr.Rd
      Status: 403
      Message: Forbidden
    URL: https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4238883/
      From: man/calc_aki_stage.Rd
      Status: 403
      Message: Forbidden

❯ On windows-x86_64-devel (r-devel)
  checking for detritus in the temp directory ... NOTE
  Found the following files/directories:
    'lastMiKTeXException'

0 errors ✔ | 0 warnings ✔ | 2 notes ✖

## Maintainer notes

This release involves a change in maintainer from Ron Keizer to Kara Woo.

The three URLs that show 403 responses are valid and correct, but forbid
requests with `curl` in the User-Agent header.
