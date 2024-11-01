function [C0,P0] = BS(T,S0,K,r,v)
% Octave/MATLAB function to evaluate
% the no-dividend European-style
% Call and Put option price using the
% Black-Scholes formulas.
% INPUTS:                      (Example)
%   T  = time to expiry        (1 year)
%   S0 = asset spot price      ($90)
%   K  = strike price          ($95)
%   r  = riskless APR          (0.02)
%   v  = volatility            (0.15)
% OUTPUTS:
%   C0 = European-style Call premium C(0)
%   P0 = European style Put premium P(0)
% EXAMPLE:
%   [C,P] = BS(1,90,95,0.02,0.15)
%
  normcdf = @(x) 0.5*(1.0+erf(x/sqrt(2.0)));
  d1 = (log(S0/K)+T*(r+v^2/2)) / (v*sqrt(T));
  d2 = (log(S0/K)+T*(r-v^2/2)) / (v*sqrt(T));
  % Alternatively, d2=d1-v*sqrt(T);
  C0 = S0*normcdf(d1)-K*exp(-r*T)*normcdf(d2);
  P0 = K*exp(-r*T)*normcdf(-d2)-S0*normcdf(-d1);
  return
end
