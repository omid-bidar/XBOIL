%Function to evaluate superheating contribution from Plesset and Zwick
%model(1954)
function [micro] = microlayerCLLeeds(prop,dT)

C2 = 1.78; %optimized constant for the microlayer model

rhoL = prop(1,1);
rhoV = prop(1,2);
iLV = prop(1,6) - prop(1,5);
CpL = prop(1,9);
alpha = prop(1,12);
PrL = prop(1,15);

micro = 1/C2*PrL^(-0.5)*(dT*rhoL*CpL/(rhoV*iLV))*alpha^0.5;

end