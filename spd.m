%%%%%%%%blue light spectral power density%%%%
%Peak wavelength 477 %FWHM 22 %LER(lm/w) 109.8 %Intensity I 1.25(or) 1
%%sigma^2 = 18 m^2
I = 1;
lambda_b = 360:570;
lambda_bc = 477;
sigma_b = 22; %m^2
S_b = I.*(exp(lambda_b - lambda_bc).^2)./(sigma_b*10e+9).^2;

lambda_wg = 360:570;
lambda_wgc = 520;
sigma_wg = 31; %m^2
S_wg = I.*(exp(lambda_wg - lambda_wgc).^2)./(sigma_wg*10e+9).^2;
figure(1)
plot(360:570,S_b)
%hold on
%plot(360:570,S_wg)
