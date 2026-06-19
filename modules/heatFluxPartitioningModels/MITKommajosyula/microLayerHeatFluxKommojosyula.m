function microlayerHeatFlux = microLayerHeatFluxKommojosyula(wallSuperheatI)

    if wallSuperheatI < 0

        microlayerHeatFlux = 1e-16;

    else 
        
        globalParams = getGlobalParams();
    
        caseDict = globalParams.caseDict;
    
        fluidProperties = getFluidProperties(caseDict);
    
        CapillaryNumber0 = 2.16e-4 * wallSuperheatI^1.216;
    
        D_dry_by_D_ml = calcD_dry_by_D_ml(wallSuperheatI); 
    
        departureDiameter = calcDepartureDiameter(wallSuperheatI);
    
        inceptionDiameter = D_dry_by_D_ml * departureDiameter; 
    
        microlayerDiameter = inceptionDiameter / 2; 
    
        CapillaryNumber = calcCapillaryNumber(wallSuperheatI);
    
        deltaMicroLayer = 4e-6 * sqrt(CapillaryNumber / CapillaryNumber0);
    
        volumeMicroLayer = deltaMicroLayer * microlayerDiameter^2 * ...
                            (pi / 12) * ...
                            (2 - ((D_dry_by_D_ml)^2 + D_dry_by_D_ml));
    
        liquidDensity = fluidProperties.liquidDensity;
    
        latentHeat = fluidProperties.latentHeat;
    
        departureFrequency = calcDepartureFrequency(wallSuperheatI);
    
        nucleationSiteDensity = calcNucleationSiteDensity(wallSuperheatI);
    
        microlayerHeatFlux = max(...
                                    volumeMicroLayer * liquidDensity * latentHeat *...
                                    departureFrequency * nucleationSiteDensity, ...
                                    0 ...
                                  );

    end 

end 