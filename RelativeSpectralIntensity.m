function [S, S_b,S_r] = RelativeSpectralIntensity(A_1, A_2, lambda_i, lambda_1, lambda_2, Delta_lambda_1, Delta_lambda_2);
lambda = 300:1:lambda_i;
x = lambda/552-1;
S = exp(-88*(x.^2)+41*(x.^3));%sensitivity eqn proposed by Agarwal
S_b = A_1*exp(-4*log(2)*((lambda-lambda_1)/Delta_lambda_1).^2);
S_r = A_2*exp(-4*log(2)*((lambda-lambda_1)./(Delta_lambda_2*(1+0.21*sign(lambda-lambda_2)))).^2);
end