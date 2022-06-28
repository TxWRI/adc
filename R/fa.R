#' Calculate Flow Anomalies
#'
#' Flow anomalies are a dimensionless term that reflects the difference in in
#' current discharges compared to past discharges. A positive flow anomaly
#' indicates the current time period
#' \Sexpr[results=rd, stage=build]{katex::math_to_rd("T_1", displayMode = FALSE)}
#' is wetter than the precedent time period
#' \Sexpr[results=rd, stage=build]{katex::math_to_rd("T_2", displayMode = FALSE)}.
#'
#' @param discharge numeric vector of daily discharges
#' @param dates vector of dates coresponding to daily discharge measurements.
#'   Must be class \code{"Date"}.
#' @param T_1 size of period
#'   \Sexpr[results=rd, stage=build]{katex::math_to_rd("T_1", displayMode = FALSE)}
#'   preceding a given day t. Specified in the same way as the \code{by} argument
#'   in \code{\link[base]{seq.POSIXt}}.
#' @param T_2 size of period
#'   \Sexpr[results=rd, stage=build]{katex::math_to_rd("T_2", displayMode = FALSE)}
#'   preceding a given day t. Specified in the same way as the \code{by} argument
#'   in \code{seq.POSIXt}. Period T_2 is expected to be longer than T_1.
#' @param clean_up logical. runs .... prior to ....
#' @param transform on of \code{NA, log, log10},
#'
#' @return vector of numeric values corresponding to
#'   \Sexpr[results=rd, stage=build]{ katex::math_to_rd("X_{T_1}(t) - X_{T_2}(t)", displayMode = FALSE)}.
#'
#' @details The FA term describes how different the antecedant discharge
#'   conditions are for a selected temporal period compared to a selected period
#'   or day of analysis. Ryberg and Vecchia (2014) and Vechia et al. (2009)
#'   describe the flow anomaly (FA) term as:
#'   \Sexpr[results=rd, stage=build]{katex::math_to_rd("FA(t)=X_{T_1}(t) - X_{T_2}(t)") }
#'
#'  The \code{T_1} and \code{T_2} arguments can be specified as character strings
#'  containing one of \code{"sec"}, \code{"min"}, \code{"hour"}, \code{"day"},
#'  \code{"DSTday"}, \code{"week"}, \code{"month"}, \code{"quarter"}, or
#'  \code{"year"}. This is generally preceded by an integer and a space. Can also
#'  be followed by an \code{"s"}. Additionally, \code{T_2} accepts
#'  \code{"period"} which coresponds with the mean of the entire flow record.
#'
#' @references
#'  Ryberg, Karen R., and Aldo V. Vecchia. 2012. “WaterData—An R Package for
#'  Retrieval, Analysis, and Anomaly Calculation of Daily Hydrologic Time Series
#'  Data.” Open Filer Report 2012-1168. National Water-Quality Assessment
#'  Program. Reston, VA: USGS. \url{https://pubs.usgs.gov/of/2012/1168/}.
#'
#'  Vecchia, Aldo V., Robert J. Gilliom, Daniel J. Sullivan, David L. Lorenz,
#'  and Jeffrey D. Martin. 2009. “Trends in Concentrations and Use of
#'  Agricultural Herbicides for Corn Belt Rivers, 1996−2006.” Environmental
#'  Science & Technology 43 (24): 9096–9102.
#'  \url{https://doi.org/10.1021/es902122j}.
#'
#' @export
#' @importFrom runner runner
#' @importFrom katex math_to_rd
#' @examples
#'  ## examples from Ryberg & Vechia 2012
#'  ## Long-term Flow Anomaly LTFA
#'  LTFA <- fa(lavaca$Flow,
#'             dates = lavaca$Date,
#'             T_1 = "1 year",
#'             T_2 = "period",
#'             clean_up = TRUE,
#'             transform = "log10")
#'
#'  ## Mid-term Flow Anomaly MTFA
#'  MTFA <- fa(lavaca$Flow,
#'             dates = lavaca$Date,
#'             T_1 = "1 month",
#'             T_2 = "1 year",
#'             clean_up = TRUE,
#'             transform = "log10")
#'
#'  ## Short-term Flow Anomaly STFA
#'  STFA <- fa(lavaca$Flow,
#'             dates = lavaca$Date,
#'             T_1 = "1 day",
#'             T_2 = "1 month",
#'             clean_up = TRUE,
#'             transform = "log10")

fa <- function(discharge,
               dates,
               T_1,
               T_2,
               clean_up = FALSE,
               transform = "log10") {

  check_qd_class(discharge, dates)

  if (!is.logical(clean_up)) {
    stop("clean_up must be a logical (TRUE or FALSE)")
  }

  ## logic that dictates if discharge record needs to be cleaned up
  if(isTRUE(clean_up)) {
    discharge <- clean_flows(discharge = discharge)
  }

  ## logic that dictates if discharge is transformed prior to mean calculations or not
  if(is.na(transform)) {
    discharge <- discharge
  }
  else if(transform == "log10") {
    discharge <- log10(discharge)
  }
  else if(transform == "log") {
    discharge <- log(discharge)
  } else {
      stop("transform must be a value of NA, log, or log10")
  }

  ## check time period 1 is valid
  t_1_split <- strsplit(T_1, " ", fixed = TRUE)[[1L]]
  t_1_units <- c("secs", "mins",
             "hours", "days", "weeks", "months",
             "years", "DSTdays", "quarters")
  valid <- pmatch(t_1_split[length(t_1_split)], t_1_units)
  if(is.na(valid)) {
    stop(paste("T_1 must be one of:", noquote(deparse(bquote(.(t_1_units))))))
  }

  t_2_split <- strsplit(T_2, " ", fixed = TRUE)[[1L]]
  t_2_units <- c("secs", "mins",
                 "hours", "days", "weeks", "months",
                 "years", "DSTdays", "quarters", "period")
  valid <- pmatch(t_2_split[length(t_2_split)], t_2_units)
  if(is.na(valid)) {
    stop(paste("T_2 must be one of:", noquote(deparse(bquote(.(t_2_units))))))
  }

  ## would be useful to check that T_2 is greater than T_1


  ## time period based mean calculated with runner
  Qt1 <- runner::runner(x = discharge,
                       k = T_1,
                       lag = 1,
                       idx = dates,
                       f = function(x) mean(x, na.rm = TRUE))

  ## for QT2, can calculate the mean for the entire period
  if (T_2 == "period") {

    Qt2 <- mean(discharge, na.rm = TRUE)

  } else {
    Qt2 <- runner::runner(x = discharge,
                          k = T_2,
                          lag = 1,
                          idx = dates,
                          f = function(x) mean(x, na.rm = TRUE))
  }

  Qt1 - Qt2
}
