function quenchingHeatFlux = quenchingHeatFluxKimAndKim(wallSuperheatI)

    quenchingHeatTransferCoefficent = quenchingHeatTransferCoefficientKimAndKim(wallSuperheatI); 

    quenchingEffectiveArea = quenchingEffectiveAreaKimAndKim(wallSuperheatI); 

    subcooling = getGlobalParams().caseDict.subcooling;
    
    quenchingHeatFlux = quenchingHeatTransferCoefficent * quenchingEffectiveArea * (wallSuperheatI + subcooling); 

end