function departureDiameter = departureDiameterUnal(wallSuperheatI)

    globalParams = getGlobalParams();

    caseDict = globalParams.caseDict;

    fluidProperties = getFluidProperties(caseDict);

    pressure = caseDict.pressure * 1e5; % [Pa]

    gasDensity = fluidProperties.gasDensity;

    liquidDensity = fluidProperties.liquidDensity; 

    latentHeat = fluidProperties.latentHeat;
    
    heaterSpecificHeatCapacity = caseDict.heaterSpecificHeatCapacity;

    heaterDensity = caseDict.heaterDensity;

    heaterThermalConductivity = caseDict.heaterThermalConductivity;

    subcooling = caseDict.subcooling;

    a = (wallSuperheatI / (2 * gasDensity * latentHeat)) * ...
         sqrt((heaterSpecificHeatCapacity * heaterDensity * heaterThermalConductivity) / pi);

    if subcooling <= 3
    b = subcooling / (2 * (1 - gasDensity / liquidDensity)) * ...
        exp(subcooling / 3);
    else
        b = subcooling / (2 * (1 - gasDensity / liquidDensity));
    end

    U0 = 0.61; % [m/s]

    velocity = caseDict.velocity; 

    phi = max((velocity / U0)^0.47, 1.0); 

    departureDiameter = 2.42e-5 * pressure^(0.709) * (a / sqrt(b * phi));
end 