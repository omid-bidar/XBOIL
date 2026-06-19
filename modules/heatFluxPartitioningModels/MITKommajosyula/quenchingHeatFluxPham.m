function quenchingHeatFlux = quenchingHeatFluxPham(wallSuperheatI)

    if wallSuperheatI < 0

        quenchingHeatFlux = 1e-16;

    else 

        globalParams = getGlobalParams();

        caseDict = globalParams.caseDict;

        heaterDensity = caseDict.heaterDensity;

        heaterSpecificHeatCapacity = caseDict.heaterSpecificHeatCapacity;

        averageTemperature = 2.0; % [K]

        departureDiameter = calcDepartureDiameter(wallSuperheatI);

        departureFrequency = calcDepartureFrequency(wallSuperheatI);

        nucleationSiteDensity = calcNucleationSiteDensity(wallSuperheatI);

        dryspotDiameter = departureDiameter / 2;

        quenchingHeatFlux = heaterDensity * heaterSpecificHeatCapacity * ...
            (2/3) * pi * (dryspotDiameter/2)^3 * departureFrequency * ...
            nucleationSiteDensity * averageTemperature;
       
    end 

end