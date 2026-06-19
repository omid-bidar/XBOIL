function evaporationHeatFlux = evaporationHeatFluxKommajosyula(wallSuperheatI)

    microlayerHeatFlux = microLayerHeatFluxKommojosyula(wallSuperheatI);

    inceptionHeatFlux = inceptionHeatFluxKommajosyula(wallSuperheatI);

    evaporationHeatFlux = microlayerHeatFlux + inceptionHeatFlux ; 

end 