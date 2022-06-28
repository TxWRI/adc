test_that("fa returns errors", {
  ## discharge isn't numeric
  expect_error(fa(discharge = as.character(lavaca$Flow),
                  dates = lavaca$Date,
                  T_1 = "1 day",
                  T_2 = "period",
                  clean_up = TRUE,
                  transform = "log10"))

  ## date isn't correct class
  expect_error(fa(discharge = lavaca$Flow,
                  dates = as.character(lavaca$Date),
                  T_1 = "1 day",
                  T_2 = "period",
                  clean_up = TRUE,
                  transform = "log10"))

  ## T_1 isn't specified correctly
  expect_error(fa(discharge = lavaca$Flow,
                  dates = lavaca$Date,
                  T_1 = "period",
                  T_2 = "period",
                  clean_up = TRUE,
                  transform = "log10"))
  expect_error(fa(discharge = lavaca$Flow,
                  dates = lavaca$Date,
                  T_1 = 15,
                  T_2 = "period",
                  clean_up = TRUE,
                  transform = "log10"))

  ## T_2 isn't specified correctly
  expect_error(fa(discharge = lavaca$Flow,
                  dates = lavaca$Date,
                  T_1 = "1 day",
                  T_2 = 15,
                  clean_up = TRUE,
                  transform = "log10"))


  ## smooth isn't logical
  expect_error(fa(discharge = lavaca$Flow,
                  dates = lavaca$Date,
                  T_1 = "1 day",
                  T_2 = "period",
                  clean_up = "true",
                  transform = "log10"))

  ## transform isn't valid
  expect_error(fa(discharge = lavaca$Flow,
                  dates = lavaca$Date,
                  T_1 = "1 day",
                  T_2 = "period",
                  clean_up = "true",
                  transform = "sqrt"))
})


test_that("fa returns expected", {
  ## should return numeric same length of input
  n <- length(lavaca$Flow)

  for (i in c(NA, "log10", "log")) {
    output <- fa(discharge = lavaca$Flow,
                 dates = lavaca$Date,
                 T_1 = "1 day",
                 T_2 = "period",
                 clean_up = TRUE,
                 transform = i)
    expect_equal(length(output), n)
    expect_equal(class(output), "numeric")
  }

  for (i in c(TRUE, FALSE)) {
    output <- fa(discharge = lavaca$Flow,
                 dates = lavaca$Date,
                 T_1 = "1 day",
                 T_2 = "period",
                 clean_up = i,
                 transform = NA)
    expect_equal(length(output), n)
    expect_equal(class(output), "numeric")
  }
})
