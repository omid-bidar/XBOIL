function totalHeatFlux = totalHeatFluxRPI(wallSuperheatI)

    if wallSuperheatI < 0

        totalHeatFlux = convectionHeatFluxRPI(wallSuperheatI);

    else 

        evaporationHeatFlux = evaporationHeatFluxRPI(wallSuperheatI);
    
        quenchingHeatFlux = quenchingHeatFluxRPI(wallSuperheatI);
    
        convectionHeatFlux = convectionHeatFluxRPI(wallSuperheatI);
    
        totalHeatFlux = evaporationHeatFlux + quenchingHeatFlux + convectionHeatFlux;
    
    end 

end
% Kurul, N. (1990). Multidimensional effects in two-phase flow including
% phase change. Rensselaer Polytechnic Institute.
% https://tinyurl.com/2hj2f8rn