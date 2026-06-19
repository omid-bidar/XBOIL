function evaporationHeatFlux = evaporationHeatFluxRPI(wallSuperheatI)

    if wallSuperheatI < 0

        evaporationHeatFlux = 1e-16;

    else 

        globalParams = getGlobalParams();
    
        fluidProperties = getFluidProperties(globalParams.caseDict);
    
        latentHeat = fluidProperties.latentHeat;
    
        gasDensity = fluidProperties.gasDensity;
    
        nucleationSiteDensity = calcNucleationSiteDensity(wallSuperheatI);
    
        departureFrequency = calcDepartureFrequency(wallSuperheatI);
        
        departureDiameter = calcDepartureDiameter(wallSuperheatI);
    
        evaporationHeatFlux = (1/6) * pi * departureDiameter^3 * gasDensity * ...
            departureFrequency * nucleationSiteDensity * latentHeat;

    end 

end