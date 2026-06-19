function waitTime = waitTimeKommajosyula(wallSuperheatI)

    globalParams = getGlobalParams();

    caseDict = globalParams.caseDict;

    fluidProperties = getFluidProperties(caseDict);

    subcoolingTemperature = caseDict.subcooling;

    JakobNumberSubcooling = calcJakobNumber(subcoolingTemperature, fluidProperties);

    waitTime = 0.0061 * JakobNumberSubcooling^0.6317 / wallSuperheatI;
    
end 
