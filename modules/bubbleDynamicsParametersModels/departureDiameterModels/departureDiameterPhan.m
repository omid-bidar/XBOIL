function departureDiameter = departureDiameterPhan(wallSuperheatI)

    globalParams = getGlobalParams();

    caseDict = globalParams.caseDict;

    fluidProperties = getFluidProperties(caseDict);

    liquidDensity = fluidProperties.liquidDensity;

    gasDensity = fluidProperties.gasDensity;

    surfaceTension = fluidProperties.surfaceTension;

    contactAngle = caseDict.contactAngle;

    contactAngleRadians = deg2rad(contactAngle);

    g = 9.81; 

    departureDiameter = (6 * sqrt(3/2))^(1/3) * ...
        (liquidDensity / gasDensity) ^(-1/2) * ...
        (liquidDensity / gasDensity - 1)^(1/3) * ...
        (tan(contactAngleRadians))^(-0.25) * ...
        sqrt(surfaceTension / (g * (liquidDensity - gasDensity))); 

end 
% Phan, H. T., Caney, N., Marty, P., Colasson, S., & Gavillet, J. (2010). A
% model to predict the effect of contact angle on the bubble departure
% diameter during heterogeneous boiling. International Communications in
% Heat and Mass Transfer, 37(8), 964?969.
% https://doi.org/10.1016/j.icheatmasstransfer.2010.06.024