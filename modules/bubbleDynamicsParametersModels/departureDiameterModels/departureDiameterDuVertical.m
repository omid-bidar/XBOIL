function departureDiameter = departureDiameterDuVertical(wallSuperheatI)


    caseDict = getGlobalParams().caseDict;

    fluidProperties = getFluidProperties(caseDict);

    gasDensity = fluidProperties.gasDensity;

    liquidDensity = fluidProperties.liquidDensity;

    surfaceTension = fluidProperties.surfaceTension; 

    liquidViscosity = fluidProperties.liquidViscosity; % dynamic viscosity 

    densityRatio = gasDensity / liquidDensity;

    g = 9.81; 

    Lo = sqrt(surfaceTension / (g* (liquidDensity -  gasDensity))); 

    specificHeatCapacity = fluidProperties.liquidSpecificHeatCapacity;

    latentHeat = fluidProperties.latentHeat;

    Ja = (specificHeatCapacity * wallSuperheatI) / latentHeat; 

    Pr = calcPrandtlNumber(fluidProperties); 

    G = liquidDensity * caseDict.velocity; 

    Re_b = 0.162e-3 * G / liquidViscosity; 

    departureDiameter = 10^(-0.433) * Lo * densityRatio^(-0.018) * Ja ^0.261 *...
        Pr^(3.381) * Re_b^(-0.323);
end 