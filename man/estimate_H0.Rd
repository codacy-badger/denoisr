% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/estimate_H0.R
\name{estimate_H0}
\alias{estimate_H0}
\title{Perform an estimation of \eqn{H_0}}
\usage{
estimate_H0(data, t0 = 0, k0 = 2, sigma = NULL)
}
\arguments{
\item{data}{A list, where each element represents a curve. Each curve have to
be defined as a list with two entries:
\itemize{
\item \strong{$t} The sampling points
\item \strong{$x} The observed points.
}}

\item{t0}{Numeric, the sampling point at which we estimate \eqn{H0}. We will
consider the \eqn{8k0 - 7} nearest points of \eqn{t_0} for the estimation of
\eqn{H_0} when \eqn{\sigma} is unknown.}

\item{k0}{Numeric, the number of neighbors of \eqn{t_0} to consider. Should
be set as \eqn{k0 = (M / log(M) + 7) / 8}.}

\item{sigma}{Numeric, true value of sigma. Can be NULL.}
}
\value{
Numeric, an estimation of H0.
}
\description{
This function performs an estimation of \eqn{H_0} used for the estimation of
the bandwidth for a univariate kernel regression estimator defined over
continuous domains data using the method of \cite{add ref}.
}
\seealso{
Other estimate \eqn{H_0}: 
\code{\link{estimate_H0_deriv_list}()},
\code{\link{estimate_H0_deriv}()},
\code{\link{estimate_H0_list}()}
}
\concept{estimate \eqn{H_0}}
