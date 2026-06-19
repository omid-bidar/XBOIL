function convectionHeatFlux = convectionHeatFluxKimAndKim(wallSuperheatI)

    convectionHeatTransferCoefficient = convectionHeatTransferCoefficientKimAndKim(wallSuperheatI);

    convectionEffectiveArea = convectionEffectiveAreaKimAndKim(wallSuperheatI); 

    subcooling = getGlobalParams().caseDict.subcooling;
    
    convectionHeatFlux = convectionHeatTransferCoefficient * convectionEffectiveArea * (wallSuperheatI + subcooling);
    
end