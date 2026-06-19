function growthTime = growthTimevanStralen(wallSuperheatI)

    globalParams = getGlobalParams();

    caseDict = globalParams.caseDict;

    fluidProperties = getFluidProperties(caseDict);
    
    JakobNumber = calcJakobNumber(wallSuperheatI, fluidProperties);

    liquidThermalConductivity = fluidProperties.liquidThermalConductivity;

    liquidSpecificHeatCapacity = fluidProperties.liquidSpecificHeatCapacity;

    liquidDensity = fluidProperties.liquidDensity;

    thermalDiffusivity = liquidThermalConductivity ...
        / (liquidDensity * liquidSpecificHeatCapacity);

    departureDiameter = calcDepartureDiameter(wallSuperheatI);

    heaterThermalConductivity = caseDict.heaterThermalConductivity;

    heaterDensity = caseDict.heaterDensity;

    heaterSpecificHeatCapacity = caseDict.heaterSpecificHeatCapacity; 

    F = sqrt(liquidThermalConductivity * liquidDensity * liquidSpecificHeatCapacity) /...
         sqrt(heaterThermalConductivity * heaterDensity * heaterSpecificHeatCapacity); 

    growthTime = (departureDiameter / (2 * 1.13) * F / (JakobNumber * thermalDiffusivity^0.5))^2;

end 