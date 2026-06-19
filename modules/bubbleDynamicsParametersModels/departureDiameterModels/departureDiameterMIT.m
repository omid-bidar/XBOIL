function departureDiameter = departureDiameterMIT(wallSuperheatI)

    globalParams = getGlobalParams();

    caseDict = globalParams.caseDict;

    fluidProperties = getFluidProperties(caseDict);

    liquidDensity = fluidProperties.liquidDensity;

    gasDensity = fluidProperties.gasDensity;

    velocity = caseDict.velocity;

    subcoolingTemperature = caseDict.subcooling;

    JakobNumberSubcooling = calcJakobNumber(subcoolingTemperature, fluidProperties);

    JakobNumberSuperheat = calcJakobNumber(wallSuperheatI, fluidProperties);

    departureDiameter = 18.9e-6 * ...
                        ((liquidDensity - gasDensity) / gasDensity)^0.27 *  ...
                        JakobNumberSuperheat^0.75 * ...
                        (1 + JakobNumberSubcooling)^-0.3 * ...
                        velocity^-0.26;

end
% Kommajosyula, R. Development and assessment of a physics-based model for
% subcooled flow boiling with application to CFD. Diss. MIT, 2020.
