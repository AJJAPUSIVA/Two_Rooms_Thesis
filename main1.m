clc;
clear all;
close all;

Nmax=5;
lamda=1300e-9;
Ad=2.51e-5;
dellamda=10e-9;
Ts=6000;
Tsource=400;

% Reciver model
A=10e-2;
Ad=8e-2;
omegadl=((pi/4).^2)*(lamda.^2/A);
omegafv=(pi/4)*(Ad/A);

% Radiation power
h=6.62607004e-34;
f=2e14;
c=3e8;
delf=dellamda/c;

k=1.38064852e-23;

%P0=(h*f*delf)/(exp((h*f)/(k*Ts))-1);
P0 = 15.256*10e-05;%7.97631*10e-12;
Pb=P0*(omegafv/omegadl);

e1=1.60217662e-19
%for ik=1:Nmax
rng(1,'twister')    
data=['This is a paragraph to test. OpTic Gaming was established ',...
         'in 2006 by OpTic "Kr3w" and Ryan "J" Musselman as a Call of ',...
         'Duty sniping team.'];
s=dec2bin(data,8);
% a1=fi(uint8(data),0,8);
% yy=bin(a1);
% 
% d=numel(yy);
%% OOK Modulation
%T=[yy];
arr=str2num(s(:));%strBin(T);
ff=arr';
dd=ff(:);
ook=ookd(dd,f);


figure(1),
subplot(2,1,1)
%stem(dd,'markerfacecolor',[0 0 1]);
stairs(dd-'0','r','linewidth',5)
xlabel('Time')
ylabel('Amplitude')
subplot(2,1,2) 
plot(ook)
xlabel('Time')
ylabel('Amplitude')
    
%pause(1)   
   
%end
%% TX position
% 1. Center  %2. Edge
for Type=1:2
for abc=1:10
% %% awgn Distribution
y = awgn(ook,abc,'measured'); 

figure(2),
plot(y)
xlabel('Sample')
ylabel('Amplitude')

%% Eqn 2;
%% Add Turbulance Channel condition
if(Type==1)
Cmin=1;Cmax=2;    
else
Cmin=3;Cmax=10;
end
eta=Cmin+(Cmax-Cmin).*rand(1);
eta(1)

al=[0.1 1 10 100];

alpha=al(1);%0.1;
lamdaB=(alpha/(h.*f)).*Pb;

lamdaS=(alpha/(h.*f)).*P0;

%% APD Detection
lamdaR=lamdaB+lamdaS.*eta(1).*y

figure(3),
plot(lamdaR)
title('APD Rx Data')


%%

yk=abs(((lamdaR./mean(lamdaR))-1))
y = intdump(yk,100);

y1=y./norm(y);

figure(4),
plot(y1)
title('Integrate Dump Data');

%% Optimum Rx Architecture 
   %% MAP model
   
   Tb=100;
   Ks=lamdaS.*Tb;
   Kb=lamdaB.*Tb;
   m1=eta(1).*Ks+Kb;
   
   Rl=10;
   
   T0=290;
   m0   =Kb;
   del  =0.028;
   gcap =1.20;
   F    =7.53;%del.*gcap+(2-(1/gcap)).*(1-del)
   sigma=(2.*k.*T0.*Tb)./(e1^2.*gcap^2.*Rl)
   
   sigma0=F.*Kb;%+sigma;
   sigma1=F.*(eta(1).*Ks+Kb);%+sigma
   %f1
   f1=(1/(sqrt(2.*pi.*sigma1))).*exp(-(y1-m1).^2./(2.*sigma1))
   %f0
   f0=(1/(sqrt(2.*pi.*sigma0))).*exp(-(y1-m0).^2./(2.*sigma0))
%sigma12=
%% Dual Threshold
ik=1;
fit=0;
while(ik<=10000) 

   Th=min(y1)+(max(y1)-min(y1)).*rand(1,2); 
    
   y2=y1;
   y3=y1;
   y33=y1;
   y2(y1<=Th(1))=1;
   y2(y1>Th(1)) =0;
   
   y3(y1<=Th(2))=1;
   y3(y1>Th(2)) =0;

   f1  =(1/(sqrt(2.*pi.*sigma1))).*exp(-(y2-m1).^2./(2.*sigma1));
   f0  =(1/(sqrt(2.*pi.*sigma0))).*exp(-(y3-m0).^2./(2.*sigma0));
   
   y33(y1<=Th(1))=1;
   y33(y1>Th(1))=0;
   E=sum(abs(dd'-y33));
   
   fit1=(sum(f1) + sum(f0))./E ;
   
   if(fit<=fit1)
      fit=fit1;
      T1=Th;
      
   end
   E1(ik)=E;
   fitb(ik)=fit;
   fitc(ik)=fit1;
   ik=ik+1;
end

figure(5),
clf
plot(fitb,'-r')
hold on
plot(fitc,'-b')
xlabel('Iteration')
ylabel('Amplitude')
legend('Optimal','Each Instance')
title('Optimal Threshold')
%% Single Threshold

Xstagc=y1./eta(1);

y5(Xstagc <= T1(1))=0;
y5(Xstagc >  T1(1))=1;

figure(6),

%stem(dd,'markerfacecolor',[0 0 1]);
stairs(y5-'0','r','linewidth',2)
xlabel('Time')
ylabel('Amplitude')


if(Type==1)
    err_num1(abc)=error_count(dd',y5)./length(arr);
    fprintf('Error Rate-->%3d\n',err_num1(abc))
else
    err_num3(abc)=error_count(dd',y5)./length(arr);
    fprintf('Error Rate-->%3d\n',err_num3(abc))
end

str_x = num2str(y5);
str_x(isspace(str_x)) = '';
Rx=char(bin2dec(reshape(str_x,[],8))).';
fprintf(['Result-->' Rx '\n'])
pause(2)
end
end

figure,
bar([err_num1' err_num3'])
xlabel('TestCase')
ylabel('Error Rate')
title('Different test cases vs Error rates in room1(single detector)')
legend('Type1','Type2')
fprintf('\n\n\n')
fprintf('Sum of Error-->%3f\n',sum(err_num1))
fprintf('Sum of Error-->%3f\n',sum(err_num3))


%% Performance Analysis
Ks=0:200:1000;
a=1.05:-0.01:1;

p1=log10(sum(err_num1)).*log10(a)
p3=log10(sum(err_num3)).*log10(a)

figure,
semilogy(Ks,p1,'-*r')
hold on
semilogy(Ks,p3,'-*b')
%title('Probability of error with respect to turbulence conditions in room1')
xlabel('Ks')
ylabel('Pe')
legend('P(E)--AGC--Type1','P(E)--AGC--Type2')


%%
L={};
for ik=1:200
eta=(ik.^10);
al=[0.1 1 10 100];
alpha=al(1);%0.1;
lamdaB=(alpha/(h.*f)).*Pb;
lamdaS=(alpha/(h.*f)).*P0;
% APD Detection
L{ik}=lamdaB+lamdaS.*eta(1).*y;


end

figure,
semilogy(1:200,sum(cell2mat(L'),2),'-*r')
title('Channel responsivity vs received signal power(room1)')
xlabel('eta')
ylabel('Recived Signal after APD(Watts)')


