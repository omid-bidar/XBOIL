function evaporationHeatFlux = evaporationHeatFluxKimAndKim(wallSuperheatI)

    evaporationHeatTransferCoefficient = evaporationHeatTransferCoefficientKimAndKim(wallSuperheatI); 

    evaporationEffectiveArea = evaporationEffectiveAreaKimAndKim(wallSuperheatI);

    evaporationHeatFlux = evaporationHeatTransferCoefficient * evaporationEffectiveArea * wallSuperheatI; 

end