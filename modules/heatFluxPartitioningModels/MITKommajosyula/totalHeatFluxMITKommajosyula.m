function totalHeatFlux = totalHeatFluxMITKommajosyula(wallSuperheatI)

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

        % globalParams = getGlobalParams();
        % if isfield(globalParams, 'quenching')
        % 
        %         quenchingHeatFlux = quenchingHeatFluxPham(wallSuperheatI);
        % 
        %         totalHeatFlux = totalHeatFlux + quenchingHeatFlux;
        % 
        % end 
        
    end 

end