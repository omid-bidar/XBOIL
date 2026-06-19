function inceptionHeatFlux = inceptionHeatFluxKommajosyula(wallSuperheatI)
    
    if wallSuperheatI < 0

        inceptionHeatFlux = 1e-16;
        
    else 

        globalParams = getGlobalParams();
    
        caseDict = globalParams.caseDict;
    
        fluidProperties = getFluidProperties(caseDict);
    
        D_dry_by_D_ml = calcD_dry_by_D_ml(wallSuperheatI);
        
        departureDiameter = calcDepartureDiameter(wallSuperheatI);
    
        inceptionDiameter = D_dry_by_D_ml * departureDiameter;
    
        gasDensity = fluidProperties.gasDensity;
    
        latentHeat = fluidProperties.latentHeat;
    
        departureFrequency = calcDepartureFrequency(wallSuperheatI);
    
        nucleationSiteDensity = calcNucleationSiteDensity(wallSuperheatI);
    
        inceptionHeatFlux = max( ...
                                  (4/3) * pi *  ...
                                  (inceptionDiameter / 2)^3 * ...
                                  gasDensity * latentHeat * ...
                                  departureFrequency * ...
                                  nucleationSiteDensity, ...
                                  0 ...
                                ); 

    end 

end 
