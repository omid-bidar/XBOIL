function totalHeatFlux = totalHeatFluxMIT(wallSuperheatI)

    if wallSuperheatI < 0

        totalHeatFlux = forcedConvectionHeatFluxKommajosyula(wallSuperheatI);

    else

        evaporationHeatFlux = evaporationHeatFluxKommajosyula(wallSuperheatI);

        slidingConductionHeatFlux = slidingConductionHeatFluxKommajosyula(wallSuperheatI);

        forcedConvectionHeatFlux = forcedConvectionHeatFluxKommajosyula(wallSuperheatI);

        quenchingHeatFlux = quenchingHeatFluxPham(wallSuperheatI);

        totalHeatFlux = evaporationHeatFlux + ...
                        slidingConductionHeatFlux + ...
                        forcedConvectionHeatFlux + ...
                        quenchingHeatFlux;

    end

end
