function forcedConvectionHeatFlux = forcedConvectionHeatFluxKommajosyula(wallSuperheatI);
    globalParams = getGlobalParams();

    caseDict = globalParams.caseDict;

    fluidProperties = getFluidProperties(caseDict);

    liquidThermalConductivity = fluidProperties.liquidThermalConductivity;
    
    liquidSpecificHeatCapacity = fluidProperties.liquidSpecificHeatCapacity;

    liquidDensity = fluidProperties.liquidDensity; 

    thermalDiffusivity = liquidThermalConductivity / ...
                        (liquidDensity * liquidSpecificHeatCapacity);


    % time taken for the thermal boundary layer to recover
    forcedConvectionHeatTransferCoefficient = calcHeatTransferCoefficient(wallSuperheatI);
    
    tStar =  (liquidThermalConductivity / forcedConvectionHeatTransferCoefficient) ^2 * ...
            (1 / (pi * thermalDiffusivity));

    nucleationSiteDensity = calcNucleationSiteDensity(wallSuperheatI);

    departureFrequency = calcDepartureFrequency(wallSuperheatI);
    
    departureDiameter = calcDepartureDiameter(wallSuperheatI); 

    liftoffDiameter = 1.2 * departureDiameter; 

    slidingArea = (1 / sqrt(nucleationSiteDensity)) * ...
            ((liftoffDiameter + departureDiameter)/2);

    slidingAreaFraction = min( ...
        1, ...
        slidingArea * nucleationSiteDensity * tStar * departureFrequency ...
        );

    subcoolingTemperature = caseDict.subcooling;

    forcedConvectionHeatFlux = (1 - slidingAreaFraction) * ...
        forcedConvectionHeatTransferCoefficient * ...
        (wallSuperheatI + subcoolingTemperature);

end 