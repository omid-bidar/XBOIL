function departureFrequency = departureFrequencyCole(wallSuperheatI)

    globalParms = getGlobalParams();

    fluidProperties = getFluidProperties(globalParms.caseDict);

    liquidDensity = fluidProperties.liquidDensity;

    gasDensity = fluidProperties.gasDensity;

    g = 9.81;

    departureDiameter = calcDepartureDiameter(wallSuperheatI);

    departureFrequency = sqrt(4 * g * (liquidDensity - gasDensity) / ...
        (3 * departureDiameter * liquidDensity)); 

end
% Cole, R. (1960). A photographic study of pool boiling in the region of
% the critical heat flux. AIChE Journal, 6(4), 533?538. Portico.
% https://doi.org/10.1002/aic.690060405