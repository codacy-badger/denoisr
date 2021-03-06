// estimate_curve.h

#ifndef ESTIMATE_CURVE_H
#define ESTIMATE_CURVE_H

#include <RcppArmadillo.h>

arma::vec epaKernelSmoothingCurve(
    const arma::vec & U, // Estimation points in U 
    const arma::vec & T, // Sampling points
    const arma::vec & Y, // Curves points
    const arma::vec & b // Smoothing bandwiths
);

arma::vec uniKernelSmoothingCurve(
    const arma::vec & U, // Estimation points in U 
    const arma::vec & T, // Sampling points
    const arma::vec & Y, // Curves points
    const arma::vec & b // Smoothing bandwiths
);
  
arma::vec betaKernelSmoothingCurve(
    const arma::vec & U, // Estimation points 
    const arma::vec & T, // Sampling points
    const arma::vec & Y, // Curves points
    const arma::vec & b // Smoothing bandwiths
);

arma::vec modifiedBetaKernelSmoothingCurve(
    const arma::vec & U, // Estimation points
    const arma::vec & T, // Sampling points
    const arma::vec & Y, // Curves points
    const arma::vec & b // Smoothing bandwiths
);
#endif