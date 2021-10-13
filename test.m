
clear all
clc
close all

% xlabel('wavelength (nm)')
% ylabel('luminous efficiency')
[ X,f ] = my_gaussiantrial(477, 22, 360, 800,100);
plot(X,f,'b')
a = fill(X,f,'b');
hold on
% [ X1,f ] = my_gaussiantrial(520, 31, 360, 800,100);
% %tt = sum(X1)
% plot(X1,f,'g')
% b =fill(X1,f,'g');
% hold on
[ X2,f ] = my_gaussiantrial(550, 7, 360, 800,100);
%yy = sum(X2)
plot(X2,f,'c')
c= fill(X2,f,'c');
hold on
[ X3,f ] = my_gaussiantrial(625, 16, 360, 800,100);
%ll = sum(X2);
plot(X3,f,'r')
d = fill(X3,f,'r');
hold on
lambda_i = 800;
lambda = 360:lambda_i;
x = lambda/555-1;
S = exp(-88*(x.^2)+41*(x.^3));%sensitivity eqn proposed by Agarwal
%%%%
% 
% lambda_i = 1120;
% lambda = 360:lambda_i;
% x = lambda/555-1;
% S = exp(-88*(x.^2)+41*(x.^3));%sensitivity eqn proposed by Agarwal
%%%%
xx = plot(lambda,S,'LineWidth',2')
xlabel('wavelength(nm)')
ylabel('luminous flux')
title('Spectral Power Density * Spectral sensitivity vs wavelength')
legend([a,b,c,d,xx],'Blue LED','Wide green LED', 'Narrow green LED', 'Red LED', 'spectral sensitivity')
yyyy = S-(X+X1+X2+X3);
nn =sum(yyyy)
% % tt = X.*S;
% % 
% % figure(3)
% % plot(tt)
