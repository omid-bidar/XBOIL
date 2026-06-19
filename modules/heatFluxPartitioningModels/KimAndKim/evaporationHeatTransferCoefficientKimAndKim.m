function evaporationHeatTransferCoefficient = evaporationHeatTransferCoefficientKimAndKim(wallSuperheatI)
    
    globalParams = getGlobalParams();

    fluidProperties = getFluidProperties(globalParams.caseDict);

    liquidThermalConductivity = fluidProperties.liquidThermalConductivity;
    
    liquidDynamicViscosity = fluidProperties.liquidViscosity;

    liquidDensity = fluidProperties.liquidDensity;

    liquidKinematicViscosity = liquidDynamicViscosity / liquidDensity;

    growthTime = calcGrowthTime(wallSuperheatI);

    evaporationHeatTransferCoefficient = 5 * liquidThermalConductivity / ...
                (2 * sqrt(liquidKinematicViscosity * growthTime));
end 