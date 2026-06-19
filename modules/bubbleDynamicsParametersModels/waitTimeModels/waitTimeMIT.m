function waitTime = waitTimeMIT(wallSuperheatI)

    globalParams = getGlobalParams();

    caseDict = globalParams.caseDict;

    fluidProperties = getFluidProperties(caseDict);

    subcoolingTemperature = caseDict.subcooling;

    JakobNumberSubcooling = calcJakobNumber(subcoolingTemperature, fluidProperties);

    waitTime = 0.0061 * JakobNumberSubcooling^0.6317 / wallSuperheatI;

end
% Kommajosyula, R. Development and assessment of a physics-based model for
% subcooled flow boiling with application to CFD. Diss. MIT, 2020.
