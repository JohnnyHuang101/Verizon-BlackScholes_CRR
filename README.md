# Verizon-BlackScholes_CRR
My analysis on verizon stocks and dividends utilizing popular financial analytics models.


I have also created a writeup detailing my descriptions so feel free to take a look :)!

<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

Johnny Huang
Dec-14-2023
An Analysis of Verizon Stocks

I conducted my analysis on the currently standard stocks for Verizon Communications Inc. (VZ) from the S&P500. Most of the calculations were carried out on Dec-14-2023 which includes key statistics such as the spot price and calculations for days into the future.

	I’ve used some sources throughout my project and those are:
To find the spot prices and dividend rates: https://www.morningstar.com/stocks/xnys/vz/dividends
To find the option chains for calls and puts: https://www.nasdaq.com/market-activity/stocks/vz
To find the riskless rates using treasury t bills: https://home.treasury.gov/resource-center/data-chart-center/interest-rates/TextView?type=daily_treasury_bill_rates&field_tdr_date_value_month=202312
Other sources are also cited where appropriate if not gathered from the above sources

To calculate the Implied volatility using both the CRR and Black-Scholes model, we look at the current published data of VZ and gather variables to be put into our function Implied_volatilities.m file.

I have chosen to specifically use the last-call options for my calculations. The reason why I chose the specific options for these calls and strike prices is that they have a large amount of trading volume, which means published implied values will have a much larger volume to work with and therefore be much closer to the true values.

The variables are all listed and described in the code and I have explicitly chosen near-the-money options for calls to calculate the implied volatilities sigma(K, T): 


Note that alongside this function that I’ve created with inspirations from the textbook, side functions such as bisection.m, BS.m, CRReur.m, and CRRparams.m are also used and those are collected through the course website.
The riskless APR is calculated by taking the average of the last 4 days of the 4 weeks maturity tranche given by (5.26+5.27+5.28+5.28)/4=5.273% = 0.05273 from the treasury website cited above.


The function Implied_volatilties.m then yields the following calculated implied volatilities through the Black-Scholes model and the Cox-Ross-Rubinstein model respectively:

Each of the rows represents the different strike prices ranging from 35-41 in increments of 1 and each of the columns represents each of the 5 different dates (see table for the PUBLISHED implied volatilities for exact dates).
All of the values are in decimal, so to convert them into percentages % we would have to multiply each value by 100. 
The CRR model takes N = 20 as standard protocols

As for the published volatility rates for this data, we have the following data extracted from the website https://www.barchart.com/stocks/quotes/VZ/options?expiration=2023-12-15-m: 




Dec 15
Dec 22
Dec 29
Jan 5
Jan 12
35
119.09%
38.99%
32.00%
28.56%
26.56%
36
57.49%
25.61%
23.93%
23.19%
23.83%
37
38.40%
21.60%
21.08%
21.30%
17.67%
38
25.10%
18.16%
17.36%
18.26%
17.08%
39
31.87%
18.15%
16.98%
17.54%
16.66%
40
53.14%
18.87%
18.93%
17.68%
17.35%
41
81.16%
0%
18.87%
19.34%
18.18%


From these results, the first thing we can notice is that, as expected, the calculated implied volatilities using the CRR and BS models are extremely similar. As for both models in comparison to the published volatility data, the general trends of data points following along the strike prices and dates both fit extremely well. There are slight differences as to each of the values, however, but that’s as expected since the volatilities are all models that try and predict future statistics using current data that’s available; the formulas used might also slightly differ.

To better visualize our implied volatilities, we can visually graph our data using either the BS or CRR model as they are effectively identical. I used the BS model and the code for creating our implied volatility surface is essentially the same as the previous one, except we add the mesh function to visualize:


To calculate the theoretical prices of an American style Call and Put options with the provided data, I will utilize the functions CRRDaeC.m and CRRDaeP.m respectively, both of which are obtained through the course website; CRRDaeC and CRRDaeP both use the function CRRD.m within them and CRRparams.m:

According to https://www.dividend.com/stocks/, the dividend payments for VZ occur quarterly. I will choose the 2 dividend dates in the year 2024, with one on Feb-01 and one expected historically on May-02, both with the value of 0.665$. I will choose the expiry T of June 21 2024 to be able to account for both these dividend payments and the complete set of parameters that will go into the function is as follows:

T = 0.52 which is 190 days over 365 in a year from today, Dec-14th
S0= 36.99 on Dec-14th
K = 33, 35, 38, 40, 42 as chosen because they are near the money
N = sqrt(190) = 13.78 = 14 as suggested
Di = [0, 0, 0, 0.665, 0, 0, 0, 0, 0, 0, 0, 0, 0.665, 0, 0, 0]; this is calculated based on N being 14, which divides 190 days into segments of around 14 days each. Then, we populate each spot with 14-day advances from today putting 0 for no payout and the dividend values for their respective dates.
R = 0.0513 average of 4 days based on 26-week US treasury T-bill rates, which is around 190 days at T
VC = [0.2342, 0.2155, 0.2063, 0.1901, 0.19] using published implied volatilities for each of the strike prices for call options at the expiry date; note that we are using individualized implied volatilities for each calculation because they vary between different strike prices as well as puts and calls, collected through https://www.barchart.com/stocks/quotes/VZ/
VP = [0.2345, 0.2198, 0.2098, 0.2060, 0.2089] published volatilities for puts

Putting these parameters into the functions CRRDaeC and CRRDaeP, we look at the value in square (1,1) of the outputted table, as this tells us the initial values. This yields us the following table: 



Call (Calculated)
Call (Published)
Put (Calculated)
Put (Published)
K = 33
4.71
5.22
0.96
0.77
K = 35
3.65
3.79
1.30
1.19
K = 38
1.65
1.9
2.73
2.42
K = 40
0.97
1.1
4.1
3.6
K = 42
0.44
0.6
5.88
5.5

Published prices are taken from https://www.barchart.com/stocks/quotes/VZ/ and represent the last closing prices

As we can see, our calculated prices complement the published data extremely well and the discrepancy between the 2 values can potentially be caused by our chosen N as it was rounded and could be more frequent


Now, if we modify our Di array such that the 2nd dividend is 20% (0.798 instead of 0.665) higher than the first, we get the following table:




Call
Put
K = 33
4.65
0.99
K = 35
3.23
1.77
K = 38
1.43
3.05
K = 40
0.74
4.42
K = 42
0.23
5.99



We see now that because the second dividend is now higher, the prices of puts increased as the prices of calls decreased by a noticeable margin, which also makes sense intuitively.


I will choose the Options with an expiry date T on Dec-22-2023 which is around 9 days from now and which does not contain any expected dividend payments.

To construct the implied binomial tree using this expiry date, we will utilize the function provided by the course website IBT123J.m (constructs tree through market Call ask prices by Rubinstein’s 1 2 3 method with Jackwerth’s generalization) with the following parameters:

S0 = 36.99 Dec-14th-2023


Call Ask Premiums $
K = 35
2.56
K = 36
1.58
K = 37
0.69
K = 38
0.17
K = 39
0.04

R = the average of the last 4 days of the 4 weeks maturity tranche given by (5.26+5.27+5.28+5.28)/4=5.273% with data collected from the treasury T-bill rates 
rho= exp(r*10/365) = 1.0014 calculated with suggested formula
W = @(x)x

Plugging all of these parameters into the function gives the following tables for each of the 6 calculated variables:


Now that we have the produced implied binomial Tree for call prices, we can then price puts of the same expiry time by first, calculating the values for such a put option, and then using backward induction to find the discounted expected prices for put options using the following formula found within the textbook on page 65:

We can utilize the matrices we calculated with the IBT123J.m function with this function that I implemented called Backwards_Induction.m with edits from the textbook to calculate the following:

Also Utilizing the Call-put parity formula found in the book to calculate the put values at the same expiry time on Dec-22nd, we obtain the following table. Note, the published data is obtained through https://www.barchart.com/stocks/quotes/VZ/overview:



Backwards Induction
Published Put premiums
Call-Put Parity
K=35
0.05189
0.02
0.0521
K=36
0.1408
0.11
0.239
K=37
0.4148
0.23
0.448
K=38
1.265
0.8
1.13
K=39
2.281
1.75
1.995



As we can see, the prices for put premiums estimated through backward induction and the call-put parity formula are both pretty similar to the published premiums on the same expiry date as the calls on Dec-22nd.


