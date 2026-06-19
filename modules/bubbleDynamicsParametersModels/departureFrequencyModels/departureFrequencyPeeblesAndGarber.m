function departureFrequency = departureFrequencyPeeblesAndGarber(wallSuperheatI)

    globalParams = getGlobalParams();

    caseDict = globalParams.caseDict;

    fluidProperties = getFluidProperties(caseDict);

    surfaceTension = fluidProperties.surfaceTension;

    liquidDensity = fluidProperties.liquidDensity;

    gasDensity = fluidProperties.gasDensity;

    g = 9.81;

    waitTime = calcWaitTime(wallSuperheatI); 

    growthTime = calcGrowthTime(wallSuperheatI); 

    departureDiameter = calcDepartureDiameter(wallSuperheatI); 

    departureFrequency = ( 1.18 * (growthTime / (growthTime + waitTime)) * ...
        ((surfaceTension * g * (liquidDensity - gasDensity))/...
        (liquidDensity^2))^(1/4) ) / departureDiameter;

end
% Peebles, F. N. (1953). Studies on the motion of gas bubbles in liquid.
% Chem. Eng. Prog., 49(2), 88-97.