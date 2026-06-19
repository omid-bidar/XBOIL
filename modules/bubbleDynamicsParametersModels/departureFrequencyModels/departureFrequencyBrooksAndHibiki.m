function departureFrequency = departureFrequencyBrooksAndHibiki(wallSuperheatI)

    globalParams = getGlobalParams();

    caseDict = globalParams.caseDict;

    fluidProperties = getFluidProperties(caseDict);

    liquidDensity = fluidProperties.liquidDensity;

    liquidThermalDiffusivity = fluidProperties.liquidThermalDiffusivity;

    gasDensity = fluidProperties.gasDensity;

    JakobNumber = calcJakobNumber(wallSuperheatI, fluidProperties);

    PrandtlNumber = calcPrandtlNumber(fluidProperties);

    departureDiameter = calcDepartureDiameter(wallSuperheatI);

    rhoStar = gasDensity / liquidDensity;

    saturationTemperature = fluidProperties.saturationTemperature; 

    wallTemperature = wallSuperheatI + saturationTemperature; 

    subcoolingTemperature = caseDict.subcooling;

    bulkTemperature =  saturationTemperature - subcoolingTemperature;   

    N_T = (wallTemperature - bulkTemperature) / wallSuperheatI;

    departureFrequency = (liquidThermalDiffusivity/departureDiameter^2) *...
        5.5 * JakobNumber^(0.82) * N_T^(-1.46) * rhoStar^(-0.93) * PrandtlNumber^(2.36); 

end
% Brooks, C. S., & Hibiki, T. (2015). Wall nucleation modeling in subcooled
% boiling flow. International Journal of Heat and Mass Transfer, 86,
% 183?196. https://doi.org/10.1016/j.ijheatmasstransfer.2015.03.005