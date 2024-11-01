function [C, P] = CRReur(T, S0, K, r, v, N)
% Octave/MATLAB function to price European Call
% and Put options using the Cox-Ross-Rubinstein
% (CRR) binomial pricing model.
% INPUTS:                             (Example)
%    T =  expiration time in years     (1)
%    S0 = spot stock price             (90)
%    K =  strike price                 (95)
%    r =  riskless yield per year      (0.02)
%    v =  volatility; must be >0       (0.15)
%    N =  height of the binomial tree  (10)
% OUTPUTS:
%    C =  price of the Call option at all (n,j).
%    P  =  price of the Put option at all (n,j).
% EXAMPLE:
%    [C, P] = CRReur(1, 90, 95, 0.02, 0.15, 10);
%    C(1,1),P(1,1)  % to get just C(0) and P(0)
%
  [pu,up,R] = CRRparams(T,r,v,N); % Use CRR values 
  C=zeros(N+1,N+1); P=zeros(N+1,N+1); % Initial C,P
  for j=0:N  % Set terminal values at time step N
   SNj=S0*up^(2*j-N);        % Expiry price S(N,j)
   C(N+1,j+1)=max(SNj-K, 0); % Plus part of (SNj-K)
   P(N+1,j+1)=max(K-SNj, 0); % Plus part of (K-SNj)
  end
  for n=N-1:-1:0   %  Price earlier grid values
   for j=0:n % ...with the backward pricing formula
    C(n+1,j+1)=(pu*C(n+2,j+2)+(1-pu)*C(n+2,j+1))/R;
    P(n+1,j+1)=(pu*P(n+2,j+2)+(1-pu)*P(n+2,j+1))/R;
   end
  end
  return; % Prices in C and P are now fully defined.
end
