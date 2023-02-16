#' Approximate the Instantaneous Rate of Change
#'
#' Estimate the rate of change or first derivative of the raw mean daily streamflow or the smoothed cubic spline fit between time and mean daily streamflow.
#' @param discharge numeric vector of mean daily discharges
#' @param dates vector of dates corresponding to daily discharge measurements.
#'   Must be class \code{"Date"}.
#' @param smooth logical indicating if the first derivative is calculated using a cubic smoothing spline function. Defaults is \code{TRUE}.
#'
#' @return Numeric vector with the estimated streamflow rate of change.
#' @export
#' @importFrom stats predict smooth.spline
#' @examples
#' ## calculate the first deriv of the smoothed function between Date and streamflow
#' rate <- rate_of_change(lavaca$Flow, lavaca$Date)
#' head(rate)
#'
#' ## Return the first deriv on raw measurements
#' rate2 <- rate_of_change(lavaca$Flow, lavaca$Date, smooth = FALSE)
#' head(rate2)
#'
rate_of_change <- function(discharge,
                           dates,
                           smooth = TRUE) {
  ##check that dates are Dates or numeric
  check_qd_class(discharge, dates)

  if (!is.logical(smooth)) {
    stop("smooth must be a logical (TRUE or FALSE)")
  }


  # calculate dQ/d(t)t
  if (!isTRUE(smooth)){
    diff.prime <- c(NA, diff(discharge)/as.numeric(diff(dates)))
  } else {
    ## fit cubic smoothing spline function then approximate dQ/dT
    spl <- smooth.spline(dates, discharge, cv = FALSE, all.knots = FALSE)
    ## predict first derivative at each point
    x <- as.numeric(dates)
    diff.prime <- predict(spl, x, deriv = 1)$y
  }
  return(diff.prime)
}
