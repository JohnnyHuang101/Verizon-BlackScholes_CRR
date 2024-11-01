function computedPutPrices = calculateEuropeanPutPrices(SpotPrices, TransitionProbabilities, UpFactor, DownFactor, UpProbability, NumSteps, StrikePrices, RiskFreeRate)
% MATLAB function to price European-style put options using a binomial tree
%
% INPUTS:
%   SpotPrices - Matrix of spot prices at each node
%   TransitionProbabilities - Matrix of transition probabilities
%   UpFactor, DownFactor - Factors for the up and down movements
%   UpProbability - Matrix of up movement probabilities
%   NumSteps - Number of steps in the binomial tree
%   StrikePrices - Array of strike prices
%   RiskFreeRate - Riskless return
%
% OUTPUT:
%   computedPutPrices - Array of put option prices

% Initialize array to hold put option values at each node
putOptionValues = zeros(size(SpotPrices));

% Calculate put option values at the final nodes
for j = 1:NumSteps+1
    putOptionValues(NumSteps+1, j) = max(StrikePrices(j) - SpotPrices(NumSteps+1, j), 0);
end

% Backward induction to fill the put values
for n = NumSteps:-1:1
    for j = 1:n
        % Expected value of the option at this node
        expectedValue = UpProbability(n, j) * putOptionValues(n+1, j+1) + (1 - UpProbability(n, j)) * putOptionValues(n+1, j);

        % Discount expected value to present
        putOptionValues(n, j) = expectedValue / RiskFreeRate;
    end
end

% Extract the put prices for each strike
computedPutPrices = putOptionValues(1:NumSteps+1, 1);

end

