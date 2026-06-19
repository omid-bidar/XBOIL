function quenchingHeatFlux = quenchingHeatFluxRPI(wallSuperheatI)
    
    if wallSuperheatI < 0

        quenchingHeatFlux = 1e-16; 

    else 

        globalParams = getGlobalParams();
    
        fluidProperties = getFluidProperties(globalParams.caseDict);
    
        liquidThermalConductivity = fluidProperties.liquidThermalConductivity;
    
        liquidThermalDiffusivity = fluidProperties.liquidThermalDiffusivity;
    
        % waitTime = calcWaitTime(wallSuperheatI);
    
        departureFrequency = calcDepartureFrequency(wallSuperheatI);
        
        quenchingArea = quenchingAreaRPI(wallSuperheatI);

        subcoolingTemperature = globalParams.caseDict.subcooling;
        % equation from the thesis (based on DelValle & Kenning (1985)
        % quenchingHeatFlux = waitTime * departureFrequency * quenchingArea * ...
        %     2 * liquidThermalConductivity * (wallSuperheatI + subcoolingTemperature) /...
        %     (sqrt(pi * waitTime * liquidThermalDiffusivity)); 
    
        % equation from Mikic and Rohsenow
        quenchingHeatFlux = ((2 * liquidThermalConductivity) / sqrt(pi * liquidThermalDiffusivity)) * ...
            sqrt(departureFrequency) * (wallSuperheatI + subcoolingTemperature) * ...
             quenchingArea; 
    
        % Equation in Tu et al.
        % quenchingHeatFlux = (2/sqrt(pi)) * sqrt(liquidThermalDiffusivity) * ...
            % sqrt(departureFrequency) * quenchingArea * wallSuperheatI; 
    end

end
% Mikic, B. B., & Rohsenow, W. M. (1969). A New Correlation of Pool-Boiling
% Data Including the Effect of Heating Surface Characteristics. Journal of
% Heat Transfer, 91(2), 245?250. https://doi.org/10.1115/1.3580136