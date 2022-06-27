#' Daily streamflows from USGS gage at Lavaca River
#'
#' A dataset containing dates and mean daily streamflows from USGS gage 08164000, Lavaca River in Texas.
#'
#' @format A data frame with 9132 rows and 5 variables:
#' \describe{
#'   \item{agency_cd}{agency code, character}
#'   \item{site_no}{site number, character}
#'   \item{Date}{date, Date format}
#'   \item{Flow}{mean daily stream flow, numeric}
#'   \item{Flow_cd}{tag indicate data quality, character}
#'   ...
#' }
#' @source \url{https://waterdata.usgs.gov/nwis/dv/?site_no=08164000&agency_cd=USGS}
"lavaca"
