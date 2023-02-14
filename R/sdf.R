#' Smooth Discounted Flow
#'
#' Applies exponential smoothing to discharge data.
#' @param discharge vector of discharge data (numeric).
#' @param delta the discount factor which can be any value between (0,1),
#'   defaults to 0.95. As \code{delta} approaches one, the average discounted
#'   flow approaches mean flow. Small values of delta return values closer to
#'   the current daily flow.
#'
#' @details The smooth discounted flow (SDF) was proposed by Kuhnert et al.
#'   (2012). The premise of SDF is to incorporate the influence of historical
#'   flows on flux:
#'
#'   \deqn{SDF(\delta) = d\kappa_{i-1} + (1-\delta)\hat{q}_{i-1},}
#'
#'   and
#'
#'   \deqn{\kappa_{i} = \sum_{m=1}^{i}\hat{q}_m,}

#'   for discount factor \eqn{\delta}, where \eqn{\kappa_{i}} represents
#'   cumulative flow up to the \eqn{i}th day.
#' @references Kuhnert, Petra M., Brent L. Henderson, Stephen E. Lewis, Zoe T.
#'   Bainbridge, Scott N. Wilkinson, and Jon E. Brodie. 2012. “Quantifying Total
#'   Suspended Sediment Export from the Burdekin River Catchment Using the Loads
#'   Regression Estimator Tool”
#'   Water Resources Research 48 (4). \doi{10.1029/2011WR011080}.
#' @return vector of values the same length as \code{discharge}.
#' @export
#' @examples
#' # Standard use case
#' ma <- sdf(lavaca$Flow, delta=0.95)
#' head(ma)
#'
#' # will work in tidy workflows using dplyr if installed
#' \dontrun{
#' lavaca |> mutate(ma = sdf(Flow, delta = 0.5))
#' }
#'
#'
sdf <- function(discharge, delta = 0.95) {
  # check the delta is [0,1]
  if (!is.numeric(delta)) stop("delta must be a number betwenn 0 and 1")
  if (delta >= 1) stop("delta must be between a number between 0 and 1")
  if (delta <= 0) stop("delta must be between a number between 0 and 1")

  #check that discharge is numeric
  if (!is.numeric(discharge)) stop("discharge must be a numeric vector")

  q <- discharge[1]
  output <- vapply(discharge, function(x) q <<- (1 - delta) * x + delta * q, 0)
  return(output)
}
