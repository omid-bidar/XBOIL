function convectionHeatFlux = convectionHeatFluxRPI(wallSuperheatI)

    globalParams = getGlobalParams();
    
    caseDict = globalParams.caseDict;

    fluidProperties = getFluidProperties(caseDict);

    liquidDensity = fluidProperties.liquidDensity;

    liquidSpecificHeatCapacity = fluidProperties.liquidSpecificHeatCapacity;

    velocity = caseDict.velocity;

    quenchingArea = quenchingAreaRPI(wallSuperheatI); 

    convectionArea = 1 - quenchingArea;

    convectionHeatTransferCoefficient = calcHeatTransferCoefficient(wallSuperheatI);

    subcoolingTemperature = caseDict.subcooling; 

    convectionHeatFlux = convectionArea * convectionHeatTransferCoefficient * (wallSuperheatI + subcoolingTemperature); 
    
end 
