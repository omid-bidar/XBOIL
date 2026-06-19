function departureDiameter = departureDiameterGolorinAndKolchugin(wallSuperheatI)
    
    globalParams = getGlobalParams();

    fluidProperties = getFluidProperties(globalParams.caseDict);

    JakobNumber = calcJakobNumber(wallSuperheatI, fluidProperties);
    
    % JakobNumber = calcJakobNumber(globalParams.caseDict.subcooling, fluidProperties);

    surfaceTension = fluidProperties.surfaceTension;

    liquidDensity = fluidProperties.liquidDensity;

    gasDensity = fluidProperties.gasDensity;

    liquidThermalDiffusivity = fluidProperties.liquidThermalDiffusivity;

    g = 9.81;

    departureDiameter = (0.0099 * surfaceTension / (g * (liquidDensity - gasDensity))) + ...
        ((15.6*liquidDensity / (g * (liquidDensity - gasDensity)))^(1/3) * ...
        (0.6 * liquidThermalDiffusivity * JakobNumber)); 

end 
% Golorin, V. S., & Kol'chugin, B. A. (1978). Investigation of the
% mechanism of nucleate boiling of ethyl alcohol and benzene by means of
% high-speed motion picture photography.