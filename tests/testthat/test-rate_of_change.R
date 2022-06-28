test_that("rate_of_change stops", {
  ## discharge isn't numeric
  expect_error(rate_of_change(discharge = as.character(lavaca$Flow[1:3]),
                              dates = lavaca$Date[1:3]))
  ## date isn't correct class
  expect_error(rate_of_change(discharge = lavaca$Flow[1:3],
                              dates = as.character(lavaca$Date[1:3])))

  ## smooth isn't logical
  expect_error(rate_of_change(discharge = lavaca$Flow[1:3],
                              dates = lavaca$Date[1:3],
                              smooth = "true"))
})


test_that("smoothed rate_of_change returns expected", {
  ## should return numeric same length of input
  n <- length(lavaca$Flow)
  output <- rate_of_change(lavaca$Flow,
                           lavaca$Date,
                           smooth = TRUE)
  expect_equal(length(output),
               n)
  expect_equal(class(output),
               "numeric")
})

test_that("raw rate_of_change returns expected", {
  ## should return numeric same length of input
  n <- length(lavaca$Flow)
  output <- rate_of_change(lavaca$Flow,
                           lavaca$Date,
                           smooth = FALSE)
  expect_equal(length(output),
               n)
  expect_equal(class(output),
               "numeric")
})
