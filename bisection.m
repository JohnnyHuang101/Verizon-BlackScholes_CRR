function [a,b]=bisection(f,y,a,b,tol)
% Octave/MATLAB function to perform a bisection
% search to find an interval [a,b] of width less
% than tolerance tol containing a point p such
% that f(p)=y.  Assume f(a)<y and f(b)>y.
% INPUTS:                             (Example)
%   f =   function handle               (@sin)
%   y =   target value for f(p)          (0.5)
%   a =   initial left endpoint          (0.0)
%   b =   initial right endpoint         (1.0)
%   tol  stop when abs(b-a)<tol         (1e-5)
% OUTPUTS:
%   [a,b] =  final interval endpoints
% EXAMPLE:
%   [a,b] = bisection(@sin,0.5,0.0,1.0,1e-5)
%
  while(abs(b-a)>tol) % too far apart!
    m=(a+b)/2;        % midpoint
    if(f(m)<y) a=m;   % then use [m,b]
    else b=m;         % else use [a,m]
    end
  end
  return
end
