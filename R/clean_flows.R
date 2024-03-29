#' Clean Flow Record
#'
#' Function to replace zeros in the flow record with specified value and replace negative discharge values with \code{NA}.
#' @param discharge numeric vector of discharges.
#' @param replace_0 numeric value or \code{NA} to replace zeros with. Defaults to 0.001.
#' @param replace_neg numeric value or \code{NA} to replace negative values with. Defaults to \code{NA}.
#'
#' @return numerioc vector same length as values provided in \code{discharge}.
#' @export
clean_flows <- function(discharge,
                        replace_0 = 0.001,
                        replace_neg = NA) {
  ## check discharge is numeric
  if (!is.numeric(discharge)) {
    stop("'discharge' should be a numeric vector")
  }

  ## check replace_0 is numeric or NA
  if (!is.numeric(replace_0)) {
    if (!is.na(replace_0)) {
      stop("'replace_0' must be numeric value between 0 and 10 or NA")
    }
  }

  ## check replace_0 is appropriate value
  if (replace_0 < 0 & !is.na(replace_0) ) {
    stop("'replace_0' must be numeric value between 0 and 10 or NA")
  }
  if (replace_0 > 10 & !is.na(replace_0) ) {
    stop("'replace_0' must be numeric value between 0 and 10 or NA")
  }

  ## check replace_neg is numeric or NA
  if (!is.numeric(replace_neg)) {
    if (!is.na(replace_neg)) {
      stop("'replace_neg' must be numeric value or NA")
    }
  }


  ## replace zero discharges with replace_0
  discharge_0 <- discharge == 0
  discharge[discharge_0] <- replace_0

  ## replace negative flows with neg_flows value
  discharge_neg <- discharge < 0
  discharge[discharge_neg] <- replace_neg

  return(discharge)
}
