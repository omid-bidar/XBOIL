function departureDiameter = departureDiameterDuHorizontal(wallSuperheatI)


    caseDict = getGlobalParams().caseDict;

    fluidProperties = getFluidProperties(caseDict);

    gasDensity = fluidProperties.gasDensity;

    liquidDensity = fluidProperties.liquidDensity;

    surfaceTension = fluidProperties.surfaceTension; 

    liquidViscosity = fluidProperties.liquidViscosity; % dynamic viscosity 

    densityRatio = gasDensity / liquidDensity;

    Lc = (liquidDensity * (liquidViscosity / liquidDensity)^2) / surfaceTension; 

    specificHeatCapacity = fluidProperties.liquidSpecificHeatCapacity;

    latentHeat = fluidProperties.latentHeat;

    Ja = (specificHeatCapacity * wallSuperheatI) / latentHeat; 

    Pr = calcPrandtlNumber(fluidProperties); 

    G = liquidDensity * caseDict.velocity; 

    Re_c = 0.00032 * G / liquidViscosity; 

    departureDiameter = 10^(7.196) * Lc * densityRatio^(-0.319) * Ja ^0.123 *...
        Pr^(-1.939) * Re_c^(-0.751);
end 