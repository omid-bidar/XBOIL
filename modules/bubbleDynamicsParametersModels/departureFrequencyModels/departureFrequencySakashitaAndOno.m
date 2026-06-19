function departureFrequency = departureFrequencySakashitaAndOno(wallSuperheatI)

    globalParams = getGlobalParams();

    caseDict = globalParams.caseDict;

    fluidProperties = getFluidProperties(caseDict);

    liquidDensity = fluidProperties.liquidDensity;

    liquidViscosity = fluidProperties.liquidViscosity;

    liquidKinematicViscosity = liquidViscosity / liquidDensity;

    gasDensity = fluidProperties.gasDensity;

    surfaceTension = fluidProperties.surfaceTension;

    g = 9.81;

    departureFrequency = 0.6 * ...
        ((g*(liquidDensity - gasDensity)) / liquidDensity)^(2/3) * ...
        (liquidKinematicViscosity*...
        ((g*(liquidDensity - gasDensity)*liquidDensity^2*liquidKinematicViscosity^4)/ surfaceTension^3)^(-0.25))^(-1/3);

end
% Sakashita, Hiroto, and Ayako Ono. "Boiling behaviors and critical heat
% flux on a horizontal plate in saturated pool boiling of water at high
% pressures." International Journal of Heat and Mass Transfer 52.3-4
% (2009): 744-750.