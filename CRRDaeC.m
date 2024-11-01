function [Ca,Ce,EE] = CRRDaeC(T,S0,K,Di, r,v,N) 
% Octave/MATLAB function to price American and
% European Call options on an asset decomposed
% into S=Sx+Ipv by CRRD(), using the CRR model.
% INPUTS:                             (Example)
%   T =  expiration time               (1 year)
%   S0 = stock price                      (100)
%   K =  strike price                     (101)
%   Di = dividend sequence 2:N+2    (see below)
%   r =  annualized risk-free yield      (0.02)
%   v =  volatility; must be >0          (0.15)
%   N =  height of the binomial tree       (12)
% OUTPUT:
%   Ca =  price of American Call at all (n,j).
%   Ce =  price of European Call at all (n,j).
%   EE =  Is early exercise optimal at (n,j)?
% EXAMPLE:
%   Di=[0 1 0 0 1 0 0 2 0 0 2 0 0 2]; % Di(k+1)=D_k
%   [Ca,Ce,EE]=CRRDaeC(1,100,101,Di,0.02,0.15,12);
%
  [pu,up,R]=CRRparams(T,r,v,N); % Use CRR values 
  [S,Sx,Ipv]=CRRD(T,S0,Di,r,v,N); % decompose
  Ca=zeros(N+1,N+1); Ce=zeros(N+1,N+1); % output
  EE=zeros(N,N); % early exercise T/F
  for j = 0:N  % to set terminal values at (N,j)
    xC=S(N+1,j+1)-K; % Call payoff at expiry...
    Ca(N+1,j+1)=Ce(N+1,j+1)=max(xC,0); % plus part
  end
  for n = (N-1):(-1):0 % textbook time indices
    for j = 0:n % states j={0,1,...,n} at time n
      % Backward pricing for A and E:
      bCe=(pu*Ce(n+2,j+2)+(1-pu)*Ce(n+2,j+1))/R;   
      bCa=(pu*Ca(n+2,j+2)+(1-pu)*Ca(n+2,j+1))/R;   
      xC=S(n+1,j+1)-K; % Call exercise value
      % Set prices at node (n,j):
      Ce(n+1,j+1)=bCe; % always binomial price
      Ca(n+1,j+1)=max(bCa,xC); % highest price
      % Is early exercise optimal?
      EE(n+1,j+1)=(xC>bCa); % Yes, if xC>bCa
    end
  end % ...backward induction pricing:
  return; % Ca,Ce, and EE are defined.
end
