function nucleationSiteDensity = nucleationSiteWangDhir(wallSuperheatI)
    
    globalParams = getGlobalParams();

    caseDict = globalParams.caseDict;

    contactAngle = caseDict.contactAngle;

    fluidProperties = getFluidProperties(caseDict);

    surfaceTension = fluidProperties.surfaceTension;

    gasDensity = fluidProperties.gasDensity;

    latentHeat = fluidProperties.latentHeat;

    saturationTemperature = fluidProperties.saturationTemperature; 

    Dc = 4 * surfaceTension * saturationTemperature / ...
        (gasDensity * latentHeat * wallSuperheatI) * 1e6;

    contactAnlgeRadians = deg2rad(contactAngle);

    nucleationSiteDensity = 5e9 * ( 1 - cos(contactAnlgeRadians)) * Dc^(-6);

end
% Wang, C. H., and V. K. Dhir. "Effect of surface wettability on active
% nucleation site density during pool boiling of water on a vertical
% surface." (1993): 659-669.