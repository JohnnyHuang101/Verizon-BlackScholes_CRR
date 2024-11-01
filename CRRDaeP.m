function [Pa,Pe,EE] = CRRDaeP(T,S0,K,Di,r,v,N) 
% Octave/MATLAB function to price American and
% European Put options on an asset decomposed
% into S=Sx+Dpv by CRRD(), using the CRR model.
% INPUTS:                             (Example)
%   T =  expiration time               (1 year)
%   S0 = stock price                     ($100)
%   K =  strike price                    ($101)
%   Di = dividend sequence          (see below)
%   r =  risk-free yield                 (0.02)
%   v =  volatility; must be >0          (0.15)
%   N =  height of the binomial tree       (12)
% OUTPUT:
%   Pa =  price of American Put at all (n,j).
%   Pe =  price of European Put at all (n,j).
%   EE =  Is early exercise optimal at (n,j)?
% EXAMPLE:
%   Di = [0 1 0 0 1 0 0 2 0 0 2 0 0 2]; % Di(k)=D_k
%   [Pa,Pe,EE]=CRRDaeP(1,100,101,Di,0.02,0.15,12);
%
  [pu,up,R]=CRRparams(T,r,v,N); % Use CRR values 
  [S,Sx,Dpv]=CRRD(T,S0,Di,r,v,N); % decompose
  Pa=zeros(N+1,N+1); Pe=zeros(N+1,N+1); % outputs
  EE=zeros(N,N); % early exercise T/F
  for j = 0:N % to set terminal values at (N,j)
    xP=K-S(N+1,j+1); % Put payoff at expiry
    Pa(N+1,j+1) = Pe(N+1,j+1) = max(xP,0);
  end
  % Use backward induction pricing:
  for n = (N-1):(-1):0 % times n={N-1,...,1,0}
    for j = 0:n % states j={0,1,...,n} at time n
      % Backward pricing for A and E:
      bPe=(pu*Pe(n+2,j+2)+(1-pu)*Pe(n+2,j+1))/R;   
      bPa=(pu*Pa(n+2,j+2)+(1-pu)*Pa(n+2,j+1))/R;   
      xP=K-S(n+1,j+1);  % Put exercise value
      % Set prices at node (n,j):
      Pe(n+1,j+1)=bPe; % always binomial price
      Pa(n+1,j+1)=max(bPa,xP); % highest price
      % Is early exercise optimal?
      EE(n+1,j+1)=(xP>bPa); % Yes, if xP>bPa
    end
  end
  return; % Pa, Pe, and EE are defined.
end
