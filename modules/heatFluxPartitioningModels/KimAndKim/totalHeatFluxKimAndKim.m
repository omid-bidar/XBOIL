function totalHeatFlux = totalHeatFluxKimAndKim(wallSuperheatI)
    
    evaporationHeatFlux = evaporationHeatFluxKimAndKim(wallSuperheatI);

    quenchingHeatFlux = quenchingHeatFluxKimAndKim(wallSuperheatI);
    
    convectionHeatFlux = convectionHeatFluxKimAndKim(wallSuperheatI);

    totalHeatFlux = evaporationHeatFlux + quenchingHeatFlux + convectionHeatFlux; 

end