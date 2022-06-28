test_that("sdf returns errors", {

  # retuns error when delta isn't valid
  for (i in c(-1, 2, NA)) {
    expect_error(sdf(discharge = lavaca$Flow, delta = i))
  }

  ##return error when discharge isn't valid
  expect_error(sdf(discharge = as.character(lavaca$Flow), delta = 0.95))
})

test_that("sdf returns expect values", {

  n <- length(lavaca$Flow)
  output <- sdf(discharge = lavaca$Flow, delta = 0.95)

  expect_equal(length(output), n)
  expect_type(output, "double")
})
