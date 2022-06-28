#' Baseflow Seperation
#'
#' Implements the Lyne and Hollick filter for baseflow seperation. This
#' function utilizes the approach in Ladson et al. (2013).
#' @param discharge numeric vector of daily discharge values
#' @param a alpha, numeric values between \code{[0-1]}.
#' @param n number of passes for the filter. Must be a numeric value, defaults
#'   to 3.
#' @param reflect the number of values to reflect at the start and end of
#'   \code{discharge} to reduce "warm-up" and "cool-down" issues with the
#'   recursive filter. Must be less than or equal to the length of
#'   \code{discharge}. For long discharge records this value does not matter
#'   much, for short records the reflection should approach the length of
#'   \code{discharge}. The default is 30 as implemented in Ladson et al. (2013).
#'
#' @details This function implements the Lyne-Hollick filter (Lyne and Hollick,
#'   1979) using the approach detailed in Ladson et al. (2013). The filter is:
#'   \Sexpr[results=rd, stage=build]{
#'   katex::math_to_rd("Y_{k} = \\\\alpha \\\\times Y_{k-1} + \\\\frac{1+\\\\alpha}{2} \\\\times (Q_k - Q_{k-1})") }
#'   where, \Sexpr[results=rd, stage=build]{katex::math_to_rd("Y_k",displayMode=FALSE)}
#'   is the filtered quick response at the
#'   \Sexpr[results=rd, stage=build]{katex::math_to_rd("k^{th}",displayMode=FALSE)}
#'   sample. \Sexpr[results=rd, stage=build]{katex::math_to_rd("Q_{k}",displayMode=FALSE)}
#'   is the original streamflow and \Sexpr[results=rd, stage=build]{katex::math_to_rd("\\\\alpha",displayMode=FALSE)}
#'   is the filter parameter between [0-1].
#'
#'   Ladson et al. (2013) suggest a standardized approach for applying the
#'   filter by: (1) reflecting streamflow at the start and end of the series to
#'   address warm-up and cool-down; (2) specify the initial value of each pass
#'   as the measured flow; and (3) using three passes for the filter (forward,
#'   backward, forward); Ladson et al. (2013) also provide additional
#'   suggestions for handling missing values and appropriate alpha parameter
#'   values that are not covered here.
#' @references
#'   Lyne, V., & Hollick, M. (1979, September). Stochastic time-variable
#'   rainfall-runoff modelling. In Institute of Engineers Australia National
#'   Conference (Vol. 79, No. 10, pp. 89-93). Barton, Australia: Institute of
#'   Engineers Australia.
#'
#'   Ladson, A. R., Brown, R., Neal, B., & Nathan, R. (2013). A standard
#'   approach to baseflow separation using the Lyne and Hollick filter.
#'   Australian Journal of Water Resources, 17(1), 25-34, \url{https://dx.doi.org/10.7158/W12-028.2013.17.1}.
#'
#' @note
#'   This function is based heavily on the baseflows function in the hydrostats
#'   package by Nick Bond. However, the baseflow function returns additional
#'   summary measures and utilizes different starting values. Filter outputs
#'   will vary slightly.
#'
#' @return vector of numeric values representing estimated baseflow.
#' @importFrom katex math_to_rd
#' @export
#' @examples
#' # Standard use case
#' bf <- bf_sep_lh(lavaca$Flow, a = 0.975)
#' head(bf)
#' # will work in tidy workflows using dplyr if installed
#' \dontrun{
#' lavaca |> mutate(ma = bf_sep_lh(Flow, a = 0.975))
#' }
bf_sep_lh <- function(discharge,
                   a = 0.98,
                   n = 3,
                   reflect = 30) {

  ## need to add checks for a, n, reflect. types and values.
  if(!is.numeric(a)) {
    stop("'a' must be a number")
  }

  if (a > 1 || a < 0) {
    stop("'a' must be a number between 0 and 1")
  }

  ## n should be odd
  if(!is.numeric(n)) {
    stop("'n' should be a an odd number, probably 3")
  }

  if((n%%2 == 0)) {
    stop("'n' should be an odd number")
  }

  ## reflect should be a number or NULL
  if(!is.numeric(reflect)) {
    if(!is.null(reflect)) {
      stop("'reflect' must be a numeric value or NULL")
    }
  }

  ## reflect must be smaller than length discharge
  if(!is.null(reflect)) {
    if(reflect > length(discharge)) {
      stop("Value of 'reflect' must be less than or equal to length of 'discharge'")
    }
  }


  if(!is.null(reflect)) {

    seq.length <- length(discharge)
    ## adds the reflection to the start and end of the dataset
    ## reflect should be between 1 and length of Q
    discharge <- c(discharge[reflect:1],
                   discharge,
                   discharge[seq.length:(seq.length-reflect)])
    bf <- run_filter(discharge, a, n)
    ## removes the reflection from start and end of dataset
    bf <- bf[-c(1:reflect, (length(bf)-reflect):length(bf))]
  } else {
    bf <- run_filter(discharge, a, n)
  }

  return(bf)

}


#' Lyne and Hollick Equation
#'
#' Filter equation.
#' @param Q numeric vector of discharge values
#' @param a alpha value between \code{[0-1]}
#'
#' @return vector of estimated baseflow values
#' @keywords internal
lyne_hollick <- function(Q, a) {

  qf <- vector('numeric', length=length(Q))

  qf[1] <- Q[1]

  for (i in 2:length(Q)) {

    qf[i] <- a * qf[i - 1] + 0.5*(1+a)*(Q[i] - Q[i-1])

  }

  qb <- ifelse(qf > 0, Q - qf, Q)

  return(qb)

}


#' Iterate Lyne-Hollick Filter
#'
#' Simply iterates n runs of the Lyne-Hollick filter.
#' @param Q vector of discharge values
#' @param a alpha parameter
#' @param n number of times to itterate filter.
#'
#' @return numeric vector
#' @keywords internal
#'
run_filter <- function(Q, a, n) {
  qb <- lyne_hollick(Q, a)
  if (n>2) {
    for (i in 2:n) {
      rev_qb <- rev(qb)
      qb <- lyne_hollick(rev_qb, a)
    }
  }
  return(qb)
}
