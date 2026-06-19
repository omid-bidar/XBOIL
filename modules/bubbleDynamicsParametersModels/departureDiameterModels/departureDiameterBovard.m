function departureDiameter = departureDiameterBovard(wallSuperheatI)

    globalParams = getGlobalParams();

    caseDict = globalParams.caseDict;

    fluidProperties = getFluidProperties(caseDict);

    liquidDensity = fluidProperties.liquidDensity;

    gasDensity = fluidProperties.gasDensity;

    liquidThermalDiffusivity = fluidProperties.liquidThermalDiffusivity;

    surfaceTension = fluidProperties.surfaceTension;

    gasViscosity = fluidProperties.gasViscosity; 

    velocity = caseDict.velocity;

    contactAngleRadians = deg2rad(caseDict.contactAngle);

    heaterThermalDiffusivity = caseDict.heaterThermalDiffusivity; 

    g = 9.81;

    JakobNumber = calcJakobNumber(wallSuperheatI, fluidProperties);
    % JakobNumber = calcJakobNumber(globalParams.caseDict.subcooling, fluidProperties);

    CapillaryNumber = gasViscosity * velocity / (surfaceTension * cos(contactAngleRadians));

    % model constants
    c0 = 17.95217;

    c1 = 0.0172742;

    c2 = 1.285607;

    c3 = 0.661205;

    c4 = 0.025346;

    departureDiameter = c0 * (c1 + JakobNumber^c2 * CapillaryNumber^c3 * ...
        (liquidThermalDiffusivity / heaterThermalDiffusivity)^c4) * ...
        sqrt(surfaceTension / (g * (liquidDensity - gasDensity))); 

end 
% Bovard, S., Asadinia, H., Hosseini, G., & Alavi Fazel, S. A. (2016).
% Investigation and experimental analysis of the bubble departure diameter
% in pure liquids on horizontal cylindrical heater. Heat and Mass Transfer,
% 53(4), 1199?1210. https://doi.org/10.1007/s00231-016-1885-3