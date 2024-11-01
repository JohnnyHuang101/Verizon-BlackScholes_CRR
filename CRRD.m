function [S, Sx, Ipv] = CRRD(T, S0, Di, r, v, N) 
% Octave/MATLAB function to model an asset price
% as a risky ex-dividend price Sx plus a riskless
% dividend cash flow present value Ipv, using the
% Cox-Ross-Rubinstein (CRR) binomial pricing model.
% INPUTS:                               (Example)
%   T  =  expiration time                (1 year)
%   S0 =  spot stock price                  (100)
%   Di =  2:N+2 dividends in a vector (see below)
%   r  =  constant risk-free annual yield  (0.02)
%   v  =  volatility; must be >0           (0.15)
%   N  =  height of the binomial tree        (12)
% OUTPUTS:
%   S =  cum-dividend binomial tree at all (n,j).
%   Sx =  ex-dividend binomial tree at all (n,j).
%   Ipv =  dividend present value at all n.
% EXAMPLE:
%   Di=[0 1 0 0 1 0 0 2 0 0 2 0 0 2]; % Di(k+1)=d_k
%   [S,Sx,Ipv]=CRRD(1,100,Di, 0.02, 0.15, 12);
%
  [pu,up,R] = CRRparams(T,r,v,N); % Use CRR values 
  Sx=zeros(N+1,N+1); S=zeros(N+1,N+1);
  Ipv=zeros(1,N+1); % ...allocate output matrices
  Ipv(N+1)=Di(N+2)/R; % ignore Di(n+1)=d_n if n>N+1
  for n=(N-1):(-1):0  % textbook time indices
    Ipv(n+1)=(Ipv(n+2)+Di(n+2))/R; % Di(n)=d_{n+1}
  end  % ...backward recursion for Ipv.
  Sx(1,1)=S0-Ipv(1); S(1,1)=S0; % initial values
  for n=1:N     % textbook time indices
    for j=0:n   % states j={0,1,...,n} at time n
      Sx(n+1,j+1)=Sx(1,1)*up^(2*j-n);
      S(n+1,j+1)=Sx(n+1,j+1)+Ipv(n+1);
    end
  end  % ...forward recursion for Sx and S.
  return; % Prices are in S, Sx, and Ipv.
end
