function heatTransferCoefficient = calcHeatTransferCoefficient(wallSuperheatI)
    
    globalParams = getGlobalParams();

    caseDict = globalParams.caseDict;

    hydraulicDiameter = caseDict.hydraulicDiameter;

    fluidProperties = getFluidProperties(caseDict);

    liquidThermalConductivity = fluidProperties.liquidThermalConductivity;

    NusseltNumber = calcNusseltNumber(wallSuperheatI);

    heatTransferCoefficient = (NusseltNumber * liquidThermalConductivity) /...
                               hydraulicDiameter; 

end 