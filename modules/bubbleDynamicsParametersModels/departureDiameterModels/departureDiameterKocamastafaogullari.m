function departureDiameter = departureDiameterKocamastafaogullari(wallSuperheatI)

    globalParams = getGlobalParams();

    fluidProperties = getFluidProperties(globalParams.caseDict);

    surfaceTension = fluidProperties.surfaceTension;

    liquidDensity = fluidProperties.liquidDensity;

    gasDensity = fluidProperties.gasDensity;

    g = 9.81;

    theta_deg = globalParams.caseDict.contactAngle;

    departureDiameter = 2.6416e-5 * theta_deg * ...
        sqrt(surfaceTension / (g * (liquidDensity - gasDensity))) * ...
        ((liquidDensity - gasDensity)/gasDensity) ^(0.9); 

end 
%Kocamustafaogullari, G. (1983). Pressure dependence of bubble departure
%diameter for water. International Communications in Heat and Mass
%Transfer, 10(6), 501?509. https://doi.org/10.1016/0735-1933(83)90057-x