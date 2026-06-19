function convectionHeatTransferCoefficient = convectionHeatTransferCoefficientKimAndKim(wallSuperheatI)
    
    globalParams = getGlobalParams();

    fluidProperties = getFluidProperties(globalParams.caseDict);

    liquidThermalConductivity = fluidProperties.liquidThermalConductivity;

    liquidDensity = fluidProperties.liquidDensity;

    liquidSpecificHeatCapacity = fluidProperties.liquidSpecificHeatCapacity;

    liquidThermalDiffusivity = liquidThermalConductivity / (liquidDensity * liquidSpecificHeatCapacity); 
    
    waitTime = calcWaitTime(wallSuperheatI);

    convectionHeatTransferCoefficient = liquidThermalConductivity / ...
        sqrt(pi * liquidThermalDiffusivity * waitTime); 
    
end 