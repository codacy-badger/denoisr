################################################################################
#         Functions for H0 parameter estimation using regularity               #
################################################################################


#' Perform an estimation of \eqn{H_0}
#' 
#' This function performs an estimation of \eqn{H_0} used for the estimation of
#' the bandwidth for a univariate kernel regression estimator defined over 
#' continuous domains data using the method of \cite{add ref}. 
#' 
#' @importFrom magrittr %>%
#'
#' @family estimate \eqn{H_0}
#' 
#' @param data A list, where each element represents a curve. Each curve have to
#'  be defined as a list with two entries:
#'  \itemize{
#'   \item \strong{$t} The sampling points
#'   \item \strong{$x} The observed points.
#'  } 
#' @param t0 Numeric, the sampling point at which we estimate \eqn{H0}. We will 
#'  consider the \eqn{8k0 - 7} nearest points of \eqn{t_0} for the estimation of
#'  \eqn{H_0} when \eqn{\sigma} is unknown.
#' @param k0 Numeric, the number of neighbors of \eqn{t_0} to consider. Should 
#'  be set as \eqn{k0 = (M / log(M) + 7) / 8}.
#' @param sigma Numeric, true value of sigma. Can be NULL.
#'
#' @return Numeric, an estimation of H0.
estimate_H0 <- function(data, t0 = 0, k0 = 2, sigma = NULL) {

  theta <- function(v, k, idx) (v[idx + 2 * k - 1] - v[idx + k])**2

  first_part <- 0
  second_part <- 0
  two_log_two <- 2 * log(2)
  if (is.null(sigma)) { # Case where sigma is unknown
    idxs <- data %>%
      purrr::map_dbl(~ min(order(abs(.x$t - t0))[seq_len(8 * k0 - 6)]))
    a <- data %>%
      purrr::map2_dbl(idxs, ~ theta(.x$x, k = 4 * k0 - 3, idx = .y)) %>%
      mean()
    b <- data %>%
      purrr::map2_dbl(idxs, ~ theta(.x$x, k = 2 * k0 - 1, idx = .y)) %>%
      mean()
    c <- data %>%
      purrr::map2_dbl(idxs, ~ theta(.x$x, k = k0, idx = .y)) %>%
      mean()
    if ((a - b > 0) & (b - c > 0) & (a - 2 * b + c > 0)) {
      first_part <- log(a - b)
      second_part <- log(b - c)
    }
  } else { # Case where sigma is known
    idxs <- data %>%
      purrr::map_dbl(~ min(order(abs(.x$t - t0))[seq_len(4 * k0 - 2)]))
    a <- data %>%
      purrr::map2_dbl(idxs, ~ theta(.x$x, k = 2 * k0 - 1, idx = .y)) %>%
      mean()
    b <- data %>%
      purrr::map2_dbl(idxs, ~ theta(.x$x, k = k0, idx = .y)) %>%
      mean()
    if ((a - 2 * sigma**2 > 0) & (b - 2 * sigma**2 > 0) & (a - b > 0)) {
      first_part <- log(a - 2 * sigma**2)
      second_part <- log(b - 2 * sigma**2)
    }
  }

  (first_part - second_part) / two_log_two
}

#' Perform an estimation of \eqn{H_0} given a list of \eqn{t_0}
#' 
#' This function performs an estimation of \eqn{H_0} used for the estimation of 
#' the bandwidth for a univariate kernel regression estimator defined over 
#' continuous domains data using the method of \cite{add ref}. 
#'
#' @importFrom magrittr %>%
#'
#' @family estimate \eqn{H_0}
#' 
#' @param data A list, where each element represents a curve. Each curve have to
#'  be defined as a list with two entries:
#'  \itemize{
#'   \item \strong{$t} The sampling points
#'   \item \strong{$x} The observed points.
#'  } 
#' @param t0_list A vector of numerics, the sampling points at which we estimate 
#'  \eqn{H0}. We will consider the \eqn{8k0 - 7} nearest points of \eqn{t_0} for 
#'  the estimation of \eqn{H_0} when \eqn{\sigma} is unknown.
#' @param k0_list A vector of numerics, the number of neighbors of \eqn{t_0} to 
#'  consider. Should be set as \deqn{k0 = (M / log(M) + 7) / 8}. We can set a 
#'  different \eqn{k_0}, but in order to use the same for each \eqn{t_0}, just 
#'  put a unique numeric.
#' @param sigma Numeric, true value of sigma. Can be NULL.
#'
#' @return A vector of numeric, an estimation of \eqn{H_0} at each \eqn{t_0}.
#' @export
#' @examples 
#' estimate_H0_list(denoisr::fractional_brownian, 
#'                 t0_list = 0.5, k0_list = 6)
#' estimate_H0_list(denoisr::piecewise_fractional_brownian,
#'                 t0_list = c(0.15, 0.5, 0.85), k0_list = c(2, 4, 6))
#' estimate_H0_list(denoisr::piecewise_fractional_brownian,
#'                 t0_list = c(0.15, 0.5, 0.85), k0_list = 6)
estimate_H0_list <- function(data, t0_list, k0_list = 2, sigma = NULL) {
  if(!inherits(data, 'list')){
    data <- checkData(data)
  }
  
  t0_list %>%
    purrr::map2_dbl(k0_list, ~ estimate_H0(data, t0 = .x, k0 = .y, sigma = sigma))
}

#' Perform an estimation of \eqn{H_0} when the curves are derivables
#' 
#' This function performs an estimation of \eqn{H_0} used for the estimation of 
#' the bandwidth for a univariate kernel regression estimator defined over 
#' continuous domains data in the case the curves are derivables.
#' 
#' @importFrom magrittr %>% 
#' @importFrom KernSmooth locpoly
#' 
#' @family estimate \eqn{H_0}
#' 
#' @param data A lis, where each element represents a curve. Each curve have to
#' be defined as a list with two entries:
#' \itemize{
#'  \item \strong{$t} The sampling points
#'  \item \strong{$x} The observed points.
#' }
#' @param t0 Numeric, the sampling points at which we estimate \eqn{H_0}. We will
#' consider the \eqn{8k0 - 7} nearest points of \eqn{t_0} for the estimation of
#' \eqn{H_0} when \eqn{\sigma} is unknown.
#' @param eps Numeric, precision parameter. It is used to control how much larger 
#'  than 1, we have to be in order to consider to have a regularity larger than 1
#'  (default to 0.01).
#' @param k0 Numeric, the number of neighbors of \eqn{t_0} to consider.
#' @param sigma Numeric, true value of sigma. Can be NULL.
#' 
#' @return Numeric, an estimation of \eqn{H_0}.
estimate_H0_deriv <- function(data, t0 = 0, eps = 0.01, k0 = 2, sigma = NULL){
  
  sigma_estim <- estimate_sigma(data)
  
  H0_estim <- estimate_H0(data, t0 = t0, k0 = k0, sigma = sigma)
  cpt <- 0
  while (H0_estim > 1 + eps){
    L0 <- estimate_L0(data, t0 = t0, H0 = cpt + H0_estim, k0 = k0)
    b <- estimate_b(data, sigma = sigma_estim, H0 = cpt + H0_estim, L0 = L0)
    
    smooth <- data %>% purrr::map2(b, ~ list(
      t = .x$t,
      x = KernSmooth::locpoly(.x$t, .x$x,
        drv = 1 + cpt,
        bandwidth = .y, gridsize = length(.x$t)
      )$y
    ))
    H0_estim <- estimate_H0(smooth, t0 = t0, k0 = k0, sigma = sigma)
    cpt <- cpt + 1
  }
  cpt + H0_estim
}

#' Perform an estimation of \eqn{H_0} given a list of \eqn{t_0} when the curves
#' are derivables
#' 
#' This function performs an estimation of \eqn{H_0} used for the estimation of 
#' the bandwidth for a univariate kernel regression estimator defined over 
#' continuous domains data using the method of \cite{add ref} in the case the
#' curves are derivables.
#'
#' @importFrom magrittr %>%
#'
#' @family estimate \eqn{H_0}
#' 
#' @param data A list, where each element represents a curve. Each curve have to
#'  be defined as a list with two entries:
#'  \itemize{
#'   \item \strong{$t} The sampling points
#'   \item \strong{$x} The observed points.
#'  } 
#' @param t0_list A vector of numerics, the sampling points at which we estimate 
#'  \eqn{H0}. We will consider the \eqn{8k0 - 7} nearest points of \eqn{t_0} for 
#'  the estimation of \eqn{H_0} when \eqn{\sigma} is unknown.
#' @param eps Numeric, precision parameter. It is used to control how much larger 
#'  than 1, we have to be in order to consider to have a regularity larger than 1
#'  (default to 0.1).
#' @param k0_list A vector of numerics, the number of neighbors of \eqn{t_0} to 
#'  consider. Should be set as \deqn{k0 = (M / log(M) + 7) / 8}. We can set a 
#'  different \eqn{k_0}, but in order to use the same for each \eqn{t_0}, just 
#'  put a unique numeric.
#' @param sigma Numeric, true value of sigma. Can be NULL.
#'
#' @return A vector of numeric, an estimation of \eqn{H_0} at each \eqn{t_0}.
#' @export
#' @examples 
#' estimate_H0_list(denoisr::fractional_brownian, 
#'                 t0_list = 0.5, k0_list = 6)
#' estimate_H0_list(denoisr::piecewise_fractional_brownian,
#'                 t0_list = c(0.15, 0.5, 0.85), k0_list = c(2, 4, 6))
#' estimate_H0_list(denoisr::piecewise_fractional_brownian,
#'                 t0_list = c(0.15, 0.5, 0.85), k0_list = 6)
estimate_H0_deriv_list <- function(data, t0_list, eps = 0.01, k0_list = 2, sigma = NULL) {
  if(!inherits(data, 'list')){
    data <- checkData(data)
  }
  
  t0_list %>%
    purrr::map2_dbl(k0_list, ~ estimate_H0_deriv(data, t0 = .x, k0 = .y, sigma = sigma))
}
