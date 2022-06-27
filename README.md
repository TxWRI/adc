
<!-- README.md is generated from README.Rmd. Please edit that file -->

# adc

<!-- badges: start -->

[![license](https://img.shields.io/badge/license-MIT%20+%20file%20LICENSE-lightgrey.svg)](https://choosealicense.com/)

<!-- badges: end -->

adc provides functions to calculate discharge-based covariates useful
for rating curve regression.

## Installation

I will add installation directions later!

``` r
# FILL THIS IN! HOW CAN PEOPLE INSTALL YOUR DEV PACKAGE?
```

## Example

Flow anomalies represent how different the current discharge period is
(current day, current week, current month, etc.) from previous periods
(previous week, previous month, period of record, etc.).

``` r
library(adc)
## example code is lavaca and includes dates and mean daily flow

data(lavaca)

x <- fa(lavaca$Flow,
        dates = lavaca$Date,
        T_1 = "1 month",
        T_2 = "1 year",
        clean_up = TRUE,
        transform = "log10")

plot(lavaca$Date, x, type = "l", xlab = "Date", ylab = "Anomaly [unitless]")
```

<img src="man/figures/README-example-1.png" width="100%" />

The packages also includes functions to calculate an exponentially
weighted discounted flow, base-flow, and rate of change for mean daily
streamflow. Functions generally work well using the `mutate()` function
in dplyr to facilitate tidy workflows.
