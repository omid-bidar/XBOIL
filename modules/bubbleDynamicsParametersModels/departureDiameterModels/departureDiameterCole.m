function departureDiameter = departureDiameterCole(wallSuperheatI)

    globalParams = getGlobalParams();

    fluidProperties = getFluidProperties(globalParams.caseDict);

    % JakobNumber = calcJakobNumber(globalParams.caseDict.subcooling, fluidProperties);
    JakobNumber = calcJakobNumber(wallSuperheatI, fluidProperties);

    g = 9.81;
    
    surfaceTension = fluidProperties.surfaceTension;

    liquidDensity = fluidProperties.liquidDensity;

    gasDensity = fluidProperties.gasDensity;

    departureDiameter = 0.04 * JakobNumber * ... 
               sqrt( 2 * surfaceTension / (g * (liquidDensity - gasDensity))); 

end

% Cole, R. (1967). Bubble frequencies and departure volumes at
% subatmospheric pressures. AIChE Journal, 13(4), 779-783. Portico.
% https://doi.org/10.1002/aic.690130434