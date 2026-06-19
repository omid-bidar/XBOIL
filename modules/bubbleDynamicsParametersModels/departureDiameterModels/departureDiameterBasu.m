function departureDiameter = departureDiameterBasu(wallSuperheatI)

    globalParams = getGlobalParams();
    
    caseDict = globalParams.caseDict;

    fluidProperties = getFluidProperties(caseDict);

    subcooling = caseDict.subcooling;

    JacobNumberSuperheat = calcJakobNumber(wallSuperheatI, fluidProperties);

    JacobNumberSubcooling = calcJakobNumber(subcooling, fluidProperties);

    velocity = caseDict.velocity;

    contactAngleRad = deg2rad(caseDict.contactAngle);

    surfaceTension = fluidProperties.surfaceTension;

    liquidDensity = fluidProperties.liquidDensity;

    gasDensity = fluidProperties.gasDensity;

    g = 9.81;

    L0 = sqrt(surfaceTension / (g * (liquidDensity - gasDensity)));

    departureDiameter = L0 * (0.195 * exp(-1.5 * velocity) + 0.065) * ...
        (sin(contactAngleRad))^0.4 * JacobNumberSuperheat^0.45 * ...
        exp(-0.0065 * JacobNumberSubcooling);

   
end 