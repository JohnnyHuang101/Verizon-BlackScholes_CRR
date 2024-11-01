function [pu,up,R] = CRRparams(T,r,v,N) 
% Octave/MATLAB function to compute parameters
% for the Cox-Ross-Rubinstein (CRR) binomial tree.
% INPUTS:                             (Example)
%   T =  time to expiry                (1 year)
%   r =  riskless APR                    (0.02)
%   v =  volatility; must be >0          (0.15)
%   N =  height of the binomial tree       (10)
% OUTPUT:
%   pu  =  risk-neutral up probability.
%   up  =  up factor
%   R   =  riskless return over dt
% EXAMPLE:
%   [pu,up,R] = CRRparams(1,0.02,0.15,10)
%
  dt = T/N;       % one time step of N in [0,T]
  up = exp(v*sqrt(dt)); % up factor, will be >1
  down = 1/up;        % down factor, will be <1
  R = exp(r*dt);  % riskless return over dt
  pu = (R-down)/(up-down); % risk-neutral up prob.
  return; % Parameters are all computed
end
