%Function to evaluate wall temperature from the Chen correlation and the
%ratio between the real T profile and the single-phase T profile from the
%Kader temperature wall function

function [dT,delta,h] = wallLayerPool(data,prop,model)

rhoL = prop(1,1);
muL = prop(1,3);
kL = prop(1,7);
Pr = prop(1,15);

Dh = data(1,4);
Tsat = data(1,6);
Twall = data(1,11);

dT = Twall - Tsat;

Ra = 9.81*0.00068*dT*Dh^3/(muL^2/rhoL^2);

switch model
    
    case 'Ardron'
        h = 0.14*kL/Dh*(Ra*Pr)^(1/3);
        
    case 'Incropera'
        h = kL/Dh*(0.60 + 0.387*Ra^(1/6)/((1+(0.559/Pr)^(9/16))^(8/27)))^2;
        
    otherwise
        error('unknown pool booiling heat transfer model')
end

delta = kL/h;

end
