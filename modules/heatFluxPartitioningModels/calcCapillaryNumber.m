function CapillaryNumber = calcCapillaryNumber(wallSuperheatI)

    globalParams = getGlobalParams();

    caseDict = globalParams.caseDict;

    fluidProperties = getFluidProperties(caseDict);

    liquidViscosity = fluidProperties.liquidViscosity;

    surfaceTension = fluidProperties.surfaceTension; 

    growthConstant = calcBubbleGrowthConstant(wallSuperheatI);

    growthTime = calcGrowthTime(wallSuperheatI);

    CapillaryNumber = liquidViscosity * growthConstant / ...
                      (surfaceTension * sqrt( growthTime));

end