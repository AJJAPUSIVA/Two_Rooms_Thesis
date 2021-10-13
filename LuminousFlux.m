function [L_flux] = LuminousFlux(K_m);
fun_b = @(lambda_b) 1.044*exp((-88*(lambda_b/554).^2)+(41*3*log(lambda_b))-(41*2*log(554))-(4*log(2))-(4*2*log(lambda_b-455))+(4*2*log(27)));
pb = integral(fun_b,380,780);
fun_r = @(lambda_r) 1.097*exp((-88*(lambda_r/554).^2)+(41*3*log(lambda_r))-(41*3*log(554))-(4*log(2))-(4*2*log(lambda_r-455))+(4*2*log(147*(1+0.21*sign(lambda_r-574)))));
pr = integral(fun_r,380,780);
L_flux = K_m*(pb+pr);
end