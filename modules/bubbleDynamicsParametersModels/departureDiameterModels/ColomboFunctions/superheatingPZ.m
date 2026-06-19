%Function to evaluate superheating contribution from Plesset and Zwick
%model(1954)
function [sh] = superheatingPZ(data,prop,Tsh)

rhoV = prop(1,2);
iLV = prop(1,6) - prop(1,5);
kL = prop(1,7);
alpha = prop(1,12);
Tsat = data(1,6);

sh = (3/pi)^0.5*kL*(Tsh-Tsat)/(rhoV*iLV*alpha^0.5);

end