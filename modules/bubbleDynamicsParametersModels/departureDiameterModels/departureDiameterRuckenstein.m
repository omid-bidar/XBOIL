function departureDiameter = departureDiameterRuckenstein(wallSuperheatI)

    globalParams = getGlobalParams();

    fluidProperties = getFluidProperties(globalParams.caseDict);

    liquidDensity = fluidProperties.liquidDensity;

    gasDensity = fluidProperties.gasDensity;

    surfaceTension = fluidProperties.surfaceTension;

    liquidThermalDiffusivity = fluidProperties.liquidThermalDiffusivity;

    JakobNumber = calcJakobNumber(wallSuperheatI, fluidProperties);

    % JakobNumber = calcJakobNumber(globalParams.caseDict.subcooling, fluidProperties);

    g = 9.81;

    departureDiameter = (3 * pi^2 * liquidDensity * liquidThermalDiffusivity^2 *...
        g^0.5 * sqrt(liquidDensity - gasDensity) / surfaceTension^(3/2)) * ...
        JakobNumber^(4/3) * sqrt(2*surfaceTension / ( g * (liquidDensity - gasDensity))); 

end
% Ruckenstein, R. "Recent trends in boiling heat transfer research." Appl.
% Mech. Rev 17 (1964): 663-672.