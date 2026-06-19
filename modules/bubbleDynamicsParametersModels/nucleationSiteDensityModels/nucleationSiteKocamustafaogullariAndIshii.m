function nucleationSite = nucleationSiteKocamustafaogullariAndIshii(wallShuperheatI)

    globalParams = getGlobalParams();

    caseDict = globalParams.caseDict;

    fluidProperties = getFluidProperties(caseDict);

    liquidDensity = fluidProperties.liquidDensity;

    gasDensity = fluidProperties.gasDensity;

    surfaceTension = fluidProperties.surfaceTension;

    saturationTemperature = fluidProperties.saturationTemperature;

    latentHeat = fluidProperties.latentHeat; 

    % departure diameter from Fritz
    departureDiameter = departureDiameterFrits(wallShuperheatI);

    % modified departure diameter for higher pressures
    departureDiameter = 0.0012 * ((liquidDensity - gasDensity) / gasDensity)^0.9 *...
        departureDiameter;

    rhoStar = (liquidDensity - gasDensity) / gasDensity;

    fRhoStar = 2.157e-7 * rhoStar^(-3.2) * (1 + 0.0049*rhoStar)^(4.13);

    R_g = 461.52;               % Specific gas constant for water (J/kgK)

    T_w = saturationTemperature + wallShuperheatI; 

    exponent_term = exp((latentHeat * wallShuperheatI) / (R_g * saturationTemperature * T_w)) - 1;

    P = caseDict.pressure * 1e5;        % assume in bar, so convert to Pascals.

    Rc = 2 * surfaceTension * (1 + gasDensity / liquidDensity) / (P * exponent_term); 
    
    % simplified version of equation above, for low pressures
    % Rc = 2 * surfaceTension * saturationTemperature / (gasDensity * latentHeat * wallShuperheatI);

    RcStar = (2 * Rc) / departureDiameter;

    nucleationSite = (fRhoStar * RcStar^(-4.4)) / departureDiameter^2;
    
end
% G. Kocamustafaogullari, M. Ishii, Interfacial area and nucleation site density in
% boiling systems, Int. J. Heat Mass Transfer 26 (9) (1983) 1377–1387.