function departureDiameter = departureDiameterDu(wallSuperheatI)


    caseDict = getGlobalParams().caseDict;

    fluidProperties = getFluidProperties(caseDict);

    gasDensity = fluidProperties.gasDensity;

    liquidDensity = fluidProperties.liquidDensity;

    surfaceTension = fluidProperties.surfaceTension; 

    liquidViscosity = fluidProperties.liquidViscosity; % dynamic viscosity 

    densityRatio = gasDensity / liquidDensity;

    Lc = liquidDensity * (liquidViscosity / liquidDensity)^2 / surfaceTension; 

    subcooling = caseDict.subcooling;

    specificHeatCapacity = fluidProperties.liquidSpecificHeatCapacity;

    latentHeat = fluidProperties.latentHeat;

    Ja_N_w = (specificHeatCapacity * subcooling) / latentHeat; 

    Pr = calcPrandtlNumber(fluidProperties); 

    G = liquidDensity * caseDict.velocity; 

    Re_c = 0.00032 * G / liquidViscosity; 

    departureDiameter = 1e7 * Lc * densityRatio^(-0.319) * Ja_N_w ^0.123 *...
        Pr^(-1.939) * Re_c^(-0.751);
end 