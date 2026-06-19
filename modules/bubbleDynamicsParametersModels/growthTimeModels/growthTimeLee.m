function growthTime = growthTimeLee(wallSuperheatI)
    
    globalParams = getGlobalParams();

    caseDict = globalParams.caseDict;

    fluidProperties = getFluidProperties(caseDict);

    liquidDensity = fluidProperties.liquidDensity;

    liquidThermalDiffusivity = fluidProperties.liquidThermalDiffusivity;

    surfaceTension = fluidProperties.surfaceTension;

    departureDiameter = calcDepartureDiameter(wallSuperheatI);

    JakobNumber = calcJakobNumber(wallSuperheatI, fluidProperties);

    growthTime = 67.5 * JakobNumber * liquidThermalDiffusivity * ...
        liquidDensity * departureDiameter / surfaceTension; 

end
% Lee, H. C., Oh, B. D., Bae, S. W., & Kim, M. H. (2003). Single bubble
% growth in saturated pool boiling on a constant wall temperature surface.
% International Journal of Multiphase Flow, 29(12), 1857?1874.
% https://doi.org/10.1016/j.ijmultiphaseflow.2003.09.003