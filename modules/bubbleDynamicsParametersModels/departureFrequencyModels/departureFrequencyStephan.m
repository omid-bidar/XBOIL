function departureFrequency = departureFrequencyStephan(wallSuperheatI)

    globalParams = getGlobalParams();

    caseDict = globalParams.caseDict;

    fluidProperties = getFluidProperties(caseDict);

    surfaceTension = fluidProperties.surfaceTension;

    liquidDensity = fluidProperties.liquidDensity;

    g = 9.81;

    departureDiameter = calcDepartureDiameter(wallSuperheatI);

    departureFrequency = (1 / (pi * departureDiameter)) * ...
        sqrt((g/2) * (departureDiameter + ...
        (4*surfaceTension)/(liquidDensity * g * departureDiameter)));

end
% Stephan, K. (1992). Enhancement of Heat Transfer During Boiling. Heat
% Transfer in Condensation and Boiling, 292?301.
% https://doi.org/10.1007/978-3-642-52457-8_16