# common check for first two arguments in all these functions
check_qd_class <- function(discharge, dates) {

  if (!is.numeric(discharge)) {
    stop("discharge must be 'numeric' class")
  }
  if (!(class(dates)[1] %in% c("Date", "POSIXlt", "POSIXct"))) {
    stop("dates must be a 'Date', 'POSIXct', or 'POSIClt' class")
  }
  NULL
}
