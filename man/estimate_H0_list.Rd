% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/estimate_H0.R
\name{estimate_H0_list}
\alias{estimate_H0_list}
\title{Perform an estimation of \eqn{H_0} given a list of \eqn{t_0}}
\usage{
estimate_H0_list(data, t0_list, k0_list = 2, sigma = NULL)
}
\arguments{
\item{data}{A list, where each element represents a curve. Each curve have to
be defined as a list with two entries:
\itemize{
\item \strong{$t} The sampling points
\item \strong{$x} The observed points.
}}

\item{t0_list}{A vector of numerics, the sampling points at which we estimate
\eqn{H0}. We will consider the \eqn{8k0 - 7} nearest points of \eqn{t_0} for
the estimation of \eqn{H_0} when \eqn{\sigma} is unknown.}

\item{k0_list}{A vector of numerics, the number of neighbors of \eqn{t_0} to
consider. Should be set as \deqn{k0 = (M / log(M) + 7) / 8}. We can set a
different \eqn{k_0}, but in order to use the same for each \eqn{t_0}, just
put a unique numeric.}

\item{sigma}{Numeric, true value of sigma. Can be NULL.}
}
\value{
A vector of numeric, an estimation of \eqn{H_0} at each \eqn{t_0}.
}
\description{
This function performs an estimation of \eqn{H_0} used for the estimation of
the bandwidth for a univariate kernel regression estimator defined over
continuous domains data using the method of \cite{add ref}.
}
\examples{
estimate_H0_list(denoisr::fractional_brownian, 
                t0_list = 0.5, k0_list = 6)
estimate_H0_list(denoisr::piecewise_fractional_brownian,
                t0_list = c(0.15, 0.5, 0.85), k0_list = c(2, 4, 6))
estimate_H0_list(denoisr::piecewise_fractional_brownian,
                t0_list = c(0.15, 0.5, 0.85), k0_list = 6)
}
\seealso{
Other estimate \eqn{H_0}: 
\code{\link{estimate_H0_deriv_list}()},
\code{\link{estimate_H0_deriv}()},
\code{\link{estimate_H0}()}
}
\concept{estimate \eqn{H_0}}
