%Function to evaluate wall temperature from the Chen correlation and the
%ratio between the real T profile and the single-phase T profile from the
%Kader temperature wall function

function [Tw,ratio,dT] = TwChen(data,prop)

rhoL = prop(1,1);
rhoV = prop(1,2);
muL = prop(1,3);
iLV = prop(1,6) - prop(1,5);
kL = prop(1,7);
CpL = prop(1,9);
sigma = prop(1,11);
ReL = prop(1,13);
PrSUB = prop(1,14);

N = data(1,1);
Dh = data(1,4);
psys = data(1,5);
Tsat = data(1,6);
Ub = data(1,7);
dTSUB = data(1,9);
Tb = Tsat - dTSUB;
qw = data(1,10);
Twall = data(1,11);

if qw == 0
    
    Tw = Twall;
    ratio = 1;
    dT = Twall - Tsat;
    return
    
end

%Following Klausner et al. (1993), ustar estimated from Hinze (1975)
ustar = 0.04*Ub;
%Beta for Kader(1981) wall function
Beta =(3.85*PrSUB^(1/3)-1.3)^2+2.12*log(PrSUB);
%values of yplus and Teta+ at channel centre using Kader (1981)
yplusb = (Dh/2)*ustar/(muL/rhoL);
Gammab = (PrSUB*yplusb)^4/(1+5*PrSUB^3*yplusb);
tetaplusb = PrSUB*yplusb*exp(-Gammab)+(2.12*log((1+yplusb)*1.5*(2-(Dh/2)/(Dh/2))/(1+2*(1-(Dh/2)/(Dh/2))^2))+Beta)*exp(-1/Gammab);
%non-dimensional temperature
Tstar = qw*1000/(rhoL*CpL*ustar);
%Wall temperature estimated from bulk and profile from Kader(1981)
TwSP = tetaplusb*Tstar+Tb;

if Twall == 0
    %Evaluation of wall temperature from Chen (1963)
    hc = 0.023*ReL^0.8*PrSUB^0.4*kL/Dh;
    S = 1/(1+2.53e-06*ReL^1.17); %from Situ et al. (2005)
    dT = 10;
    dTn = 1;
    
    %Cycle converges at the right wall temperature
    while abs(dT - dTn)>0.01
    
        dTn=dTn+0.25*(dT-dTn);
    
        if N == 3 || N == 4
            pw = (4.15409e-07*(Tsat+dTn)^3-3.53345e-05*(Tsat+dTn)^2+4.71149e-03*(Tsat+dTn)-9.56004e-02)*10;
        else
            pw = XSteam('psat_T',Tsat+dTn); 
        end
    
        hnb = 0.00122*(kL^0.79*CpL^0.45*rhoL^0.49/(sigma^0.5*muL^0.29*iLV^0.24*rhoV^0.24))*(Tsat+dTn+273.15)^0.24*(pw*100000-psys*100000)^0.75*S;
        Tw = Tsat+(qw*1000-hc*dTSUB)/(hnb+hc);
        dT = Tw-Tsat;
    end

   %if the value is negative, experimental value is used
   if dT < 0
       dT = Twall-Tsat;
       Tw = Twall;
   else
   end
   
else
    
    Tw = Twall;
    dT = Tw - Tsat;
    
end

ratio = (Tw-Tb)/(TwSP-Tb);

end