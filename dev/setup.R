# setup
usethis::use_build_ignore("dev")
usethis::use_data_raw()
devtools::document()
# Description
usethis::use_description(
  list(
    Title = "saeall: Sampling Allocation for Small Area Estimation",
    `Authors@R` = "c(
    person('Vincenzo', 'Nardelli', email = 'vincnardelli@gmail.com', role = c('cre', 'aut')),
    person('Piero Demetrio', 'Falorsi', role = c('ctb')),
    person('Stefano', 'Falorsi', role = c('ctb')),
    person('Paolo', 'Righi', role = c('ctb'))
    )",
    Description = "This package implements a proper statistical setting for defining 
    the sampling design for a small area estimation problem. 
    The general random sampling framework is based 
    on sampling without replacement and with varying inclusion probabilities. 
    The sample is selected with the cube method based on
    balancing sampling equations useful in the small area situation. 
    This method allows to obtain the minimum-cost sampling solution.",
    URL = "https://github.com/vincnardelli/saeall"
  )
)
usethis::use_lgpl_license()
usethis::use_tidy_description()

usethis::use_package("nloptr")
usethis::use_package("stringr")
#usethis::use_package("stats")
#usethis::use_package("spdep")
# usethis::use_pipe(export = TRUE)



# Read me
usethis::use_readme_md( open = FALSE )


# Test that
# usethis::use_testthat()
# usethis::use_test("map_generation")
# usethis::use_test("map_step")


usethis::use_git_config(
  scope = "user",
  user.name = "Vincenzo Nardelli",
  user.email = "vincnardelli@gmail.com"
)
usethis::use_git()


# CI
# usethis::use_travis()
# usethis::use_coverage()
# usethis::use_lifecycle_badge("experimental")
# usethis::use_github_action_check_standard(save_as="test.yaml")
# usethis::use_github_action("test-coverage")

# Website
# usethis::use_pkgdown()
# pkgdown::build_site()
# usethis::use_github_action("pkgdown")
