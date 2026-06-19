function departureFrequency = departureFrequencyZuber(wallSuperheatI)
    
    globalParams = getGlobalParams();

    caseDict = globalParams.caseDict;

    fluidProperties = getFluidProperties(caseDict);

    surfaceTension = fluidProperties.surfaceTension;

    liquidDensity = fluidProperties.liquidDensity;

    gasDensity = fluidProperties.gasDensity;

    g = 9.81;

    departureDiameter = calcDepartureDiameter(wallSuperheatI);

    departureFrequency = (1.18 / (2 * departureDiameter)) * ...
        ((surfaceTension * g * (liquidDensity - gasDensity))/liquidDensity^2)^(1/4);
    
end 
% Zuber, N. (1963). Nucleate boiling. The region of isolated bubbles and
% the similarity with natural convection. International Journal of Heat and
% Mass Transfer, 6(1), 53?78. https://doi.org/10.1016/0017-9310(63)90029-2