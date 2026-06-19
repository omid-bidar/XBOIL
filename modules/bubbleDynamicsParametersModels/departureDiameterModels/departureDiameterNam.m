function departureDiameter = departureDiameterNam(wallSuperheatI)

    globalParams = getGlobalParams();

    caseDict = globalParams.caseDict;

    fluidProperties = getFluidProperties(caseDict);

    surfaceTension = fluidProperties.surfaceTension;

    liquidDensity = fluidProperties.liquidDensity;

    gasDensity = fluidProperties.gasDensity;

    g = 9.81;

    contactAngle = caseDict.contactAngle;

    contactAngleRadians = deg2rad(contactAngle);

    departureDiameter = sqrt(24 * sin(contactAngleRadians)^2 / ...
        (2 + 3 * cos(contactAngleRadians) - (cos(contactAngleRadians))^3)) * ...
        sqrt(surfaceTension / (g * (liquidDensity - gasDensity))); 

end
% Nam, Y., Aktinol, E., Dhir, V. K., & Ju, Y. S. (2011). Single bubble
% dynamics on a superhydrophilic surface with artificial nucleation sites.
% International Journal of Heat and Mass Transfer, 54(7?8), 1572?1577.
% https://doi.org/10.1016/j.ijheatmasstransfer.2010.11.031