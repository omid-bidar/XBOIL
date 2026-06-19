function totalHeatFlux = calcTotalHeatFlux(wallSuperheatI)
    
    globalParameters = getGlobalParams();

    HFPModel = globalParameters.HFPModel;

    if HFPModel == "MIT"

        totalHeatFlux = totalHeatFluxMIT(wallSuperheatI);

    elseif HFPModel == "KimAndKim"

        totalHeatFlux = totalHeatFluxKimAndKim(wallSuperheatI); 

    elseif HFPModel == "RPI"

        totalHeatFlux = totalHeatFluxRPI(wallSuperheatI); 

    else

        error("Invalid or no heat flux partitioning model selected.")

    end 

end