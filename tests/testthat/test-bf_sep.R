test_that("bf_sep_lh returns errors", {

  #discharge is not numeric
  expect_error(
    bf_sep_lh(discharge = as.character(lavaca$Flow),
              a = 0.98,
              n = 3,
              reflect = 30))

  # a is not correct type or value
  for(i in c("0.98", -1,1.5)) {
    expect_error(
      bf_sep_lh(discharge = lavaca$Flow,
                a = i,
                n = 3,
                reflect = 30))
  }

  # n is not correct type or is not odd
  for(i in c("3", 4)) {
    expect_error(
      bf_sep_lh(discharge = lavaca$Flow,
                a = 0.98,
                n = i,
                reflect = 30))
  }

  #reflect is not the correct type, or too long
  n <- length(lavaca$Flow)+1 ## too long
  for(i in c(NA, n)) {
    expect_error(
      bf_sep_lh(discharge = lavaca$Flow,
                a = 0.98,
                n = 3,
                reflect = i))
  }
})


test_that("bf_sep_lh returns expected values", {

  n <- length(lavaca$Flow)
  for(i in c(NULL, 30)) {
    output <- bf_sep_lh(discharge = lavaca$Flow,
                        a = 0.98,
                        n = 3,
                        reflect = i)
    expect_equal(length(output), n)
    expect_type(output, "double")
  }

})
