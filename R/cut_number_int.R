#' Cut integerish data nicely
#'
#' @rdname cut_number_int
#' @param x a numeric vector which is to be converted to a factor by cutting.
#' @param n number of bins to create.
#' @param show_highest_value if `FALSE`, do not show the highest value in the label (i.e. the label would be `"100~"`).
#' @export
cut_number_int <- function(x, n, retry = 3L, show_highest_value = FALSE) {
  if (!is_scalar_integerish(n)) {
    abort("`n` must be an integer")
  }

  if (!is_scalar_integerish(retry)) {
    abort("`retry` must be an integer")
  }

  nbreaks <- n + 1
  breaks <- rep(NA_real_, nbreaks)

  x_tmp <- x
  offset <- 1
  while (TRUE) {
    probs <- seq(0, 1, length.out = nbreaks - offset + 1)
    breaks_tmp <- stats::quantile(x_tmp, probs)

    dup <- unique(breaks_tmp[duplicated(breaks_tmp)])

    # If there's no duplicated breaks, use the calculated breaks as they are
    if (length(dup) == 0) {
      if (offset > 1) {
        # After retry, there's already the lower bound is included
        breaks[offset:(nbreaks - 1)] <- breaks_tmp[-1]
      } else {
        breaks[offset:nbreaks] <- breaks_tmp
      }
      break
    }

    # If there's duplicated breaks, use them and re-calculate over the rest of
    # the data. This function handles only the cases where the inflated values
    # are on the lowest bounds.
    idx <- match(dup, unique(breaks_tmp))
    if (idx[1] != 1L || !all(diff(idx) == 1L)) {
      abort("For simplicity, this function only takes care the cases when the inflated values are on the lowest bounds")
    }

    breaks[offset:(offset + length(dup) - 1)] <- dup
    x_tmp <- x_tmp[!x_tmp %in% dup]
    offset <- offset + length(dup)
    retry <- retry - 1

    if (retry < 0 || retry > nbreaks) {
      abort("Retried too many times!")
    }

    message("Retrying calculation...")
  }

  if (offset > 1) {
    breaks <- c(-Inf, breaks[-nbreaks])
  }

  cut_integerish(x, breaks, show_highest_value = show_highest_value)
}

cut_integerish <- function(x, breaks, show_highest_value = FALSE) {
  nbreaks <- length(breaks)
  # A lower bound is not included, so flooring the breaks is the safe
  # transformation (e.g. if the original lower bound of a bin is 1.1,
  # value 1 is not included even if we floor the bound to 1).
  breaks <- floor(breaks)

  upper <- breaks[2:nbreaks]
  # Since the lower bounds are not included except for the first bin, add 1 except
  # for the first one.
  lower <- breaks[1:(nbreaks - 1)] + rep(c(0, 1), times = c(1L, nbreaks - 2))

  are_single_value <- lower == -Inf | lower == upper

  upper <- as.character(upper)
  lower <- as.character(lower)
  if (isFALSE(show_highest_value) && isFALSE(are_single_value[length(upper)])) {
    upper[length(upper)] <- ""
  }

  labels <- ifelse(are_single_value, upper, glue::glue("{lower}~{upper}"))

  cut(x, breaks = breaks, labels = labels, include.lowest = TRUE)
}

