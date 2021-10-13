function [i_led] = LedCurrent(i0,k,q,V_led,t_F,n_led);
t_K = (5/9)*(t_F-32)+273.15;%Convert temperature in kelvin
i_led = i0.*(exp((q*V_led)/(n_led*k*t_K))-1);%calculate led current
end