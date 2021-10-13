function [Pt] =Powertransmitted(K_m);
fun_b = @(lambda_b,theta) 1.044*exp(-4*log(2)*((lambda_b-455)/27).^2);
 Pb   = K_m*integral2(fun_b,420,1120,0,2*pi);
 fun_p = @(lambda_p,theta) 1.097*exp(-4*log(2)*((lambda_p-455)./(147*(1+0.21*sign(lambda_p-574)))).^2);
 Pp = K_m*integral2(fun_p,420,1120,0,2*pi);
 Pt = Pb+Pp %%%%trasmitting power
end