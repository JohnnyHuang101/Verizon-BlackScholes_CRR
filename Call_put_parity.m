K = [35 36 37 38 39];
R = 1.0014;
S0 = 36.99;
C0 = [2.56 1.58 0.69 0.17 0.04];
P0 = zeros(1, 5);

for i = 1:5
    P0(i) = C0(i) - S0 + (K(i)/R);
end

