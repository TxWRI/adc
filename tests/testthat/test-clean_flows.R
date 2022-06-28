test_that("clean_flows returns errors", {

  # wrong type
  expect_error(clean_flows(discharge = as.character(lavaca$Flow)))

  # wrong values for replace_0
  for (i in c(-1, 12, NULL)) {

    expect_error(clean_flows(discharge = lavaca$Flow,
                replace_0 = i))
  }

  expect_error(clean_flows(discharge = lavaca$Flow,
                           replace_0 = 0.001,
                           replace_neg = NULL))
})

test_that("clean_flows returns expected values", {

  n <- length(lavaca$Flow)

  output <- clean_flows(lavaca$Flow,
                        0.001,
                        NA)

  expect_equal(length(output), n)

  expect_type(output, "double")

})
