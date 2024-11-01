function [S,Q,up,down,pu,N1]=IBT123J(S0,Ks,Cs,rho,w) 
% Octave/MATLAB function to compute an implied binomial
% tree from spot prices and market European-style Call
% option ask prices, by Rubinstein's "1,2,3" method
% with Jackwerth's generalization.
% INPUTS:                                     (Example)
%   S0= spot stock price     (BAC 2021/12/11:    44.52)
%   Ks= equispaced, increasing strike prices    (40:46) 
%   Cs= Call asks   ([5.6,4.8,4.1,3.45,2.87,2.29,1.81])
%   rho= riskless return (to 2022/3/20:(exp(r*109/365))
%   w= weight function                        (w=@(x)x)
% OUTPUT:
%   S = binomial tree of stock prices at all (n,j)
%   Q = tree of probabilities of all states (n,j)
%   up = upfactors at (n,j)
%   down = downfactors at (n,j)
%   pu = risk neutral up probabilities at (n,j)
%   N1 = depth of the pruned tree
% NOTE: since Octave array indices start at 1, output
%   array value for (n,j) is stored at index (n+1,j+1).
% EXAMPLE:
%   S0=44.22; Ks=40:46; % BAC spot price and strikes
%   Cs=[5.6,4.8,4.1,3.45,2.87,2.29,1.81]; % Call asks
%   r=0.06/100; rho=exp(r*109/365); % 13-wk T-bill APR
%   [S,Q,up,down,pu,N1] = IBT123J(S0,Ks,Cs,rho,w)
%
m = length(Ks);        % expect valid Ks(1),...,Ks(m)
% Check that Ks and Cs have the same length
if(length(Cs) != m ) % expect valid Cs(1),...,Cs(m)
  error ("length(Cs)!=length(Ks)");
end
N=m+1;           % initial tree depth, before pruning
Del=Ks(2)-Ks(1); % expect Del=Ks(j)-Ks(j-1), all j
if(!(Del>0))     % expect Ks(1)<Ks(2)<...
  error("must have Ks(1)<Ks(2)")
end
for j=3:m          % expect equispaced Ks
 if( Ks(j)!= Ks(j-1)+Del )
   error("must have equispaced Ks")
 end
end
%% Generate time-T risk neutral probabilities Q(N,j):
QN=ones(1,N+1); % so QN(j+1)=Q(N,j) for j=0,...,N=m+1
for j=2:m-1    % normalized butterfly spread premiums:
  QN(j+1)=rho*(Cs(j-1)-2*Cs(j)+Cs(j+1))/Del;
end
QN(2)=0; QN(m+1)=0;   % Q(N,1) and Q(N,m) are special
QN(N+1)=rho*(Cs(m-1)-Cs(m))/Del; % Q(N,N) is special
QN(1)=1-sum(QN(2:(N+1)));  % so sum(Q(N,j))=1, as prob.
%% Generate the initial bottom row of stock prices
SN=zeros(1,N+1);  % so SN(j+1)=S(N,j) for the initial tree
b=(Cs(2)-Cs(1))/Del;   % temporary "slope" variable
SN(1)=rho*(S0-Cs(1)+Ks(1)*b)/(1+rho*b); % S(N,0) is special
SN(2:m+1)=Ks(1:m);  % S(N,j)=Ks(j) for j=1:m
SN(N+1)=Ks(m)+Del*Cs(m)/(Cs(m-1)-Cs(m)); % S(N,N) special
%% Prune the bottom row of S to use only positive Qs:
Q1=QN(QN>0);      %  subvector of the positive Q(N,j)
S1=SN(QN>0);      % ...and the corresponding S(N,j)
N1=length(Q1)-1;  % depth of the pruned tree
R=rho^(1/N1);     % new one-step riskless return
%% Initialize and assign the output binomial trees
S = zeros(N1+1,N1+1);    % array of stock prices.
Q = zeros(N1+1,N1+1);    % array of path probabilities.
pu = zeros(N1+1,N1+1);   % array of one-step up probs.
up = zeros(N1+1,N1+1);   % up factors
down = zeros(N1+1,N1+1); % down factors
S(N1+1,:)=S1; % Last row of pruned stock price tree
Q(N1+1,:)=Q1; % Last row of state probabilities tree
% Backward induction to fill the trees
for n=N1-1:-1:0
  for j=0:n
    Qup=w((j+1)/(n+1))*Q(n+2,j+2);
    Qdown=(1-w(j/(n+1)))*Q(n+2,j+1);
    Q(n+1,j+1)=Qup+Qdown;
    pu(n+1,j+1) = Qup/Q(n+1,j+1); % Eq.7.11
    S(n+1,j+1) = (pu(n+1,j+1)*S(n+2,j+2)
                  + (1-pu(n+1,j+1))*S(n+2,j+1))/R;
    up(n+1,j+1) = S(n+2,j+2)/S(n+1,j+1);   % upfactor
    down(n+1,j+1) = S(n+2,j+1)/S(n+1,j+1); % downfactor
  end
end
return;
end
