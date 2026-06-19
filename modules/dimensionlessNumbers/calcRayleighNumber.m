function RayleighNumber = calcRayleighNumber(wallSuperheatI)
    
    globalParams = getGlobalParams();

    caseDict = globalParams.caseDict;

    referenceLength = caseDict.referenceLength;

    fluidProperties = getFluidPropertiesUsingFilmTemperature(caseDict, wallSuperheatI);

    % fluidProperties = getFluidProperties(caseDict); 

    liquidThermalExpansionCoefficient = fluidProperties.liquidThermalExpansionCoefficient; 

    liquidViscosity = fluidProperties.liquidViscosity; % dynamic viscosity

    liquidDensity = fluidProperties.liquidDensity;

    liquidKinematicViscosity = liquidViscosity / liquidDensity; 

    g = 9.81;

    RayleighNumber = (g * liquidThermalExpansionCoefficient * referenceLength^3 * wallSuperheatI) /...
        liquidKinematicViscosity^2;

end 