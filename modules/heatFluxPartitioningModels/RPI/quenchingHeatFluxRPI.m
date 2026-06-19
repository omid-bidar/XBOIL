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

        % default if not provided
        quenchingRPI = "Mikic";
        if isfield(globalParams, 'quenchingRPI')
            quenchingRPI = globalParams.quenchingRPI;
        end

        if quenchingRPI == "Kurul"

            waitTime = calcWaitTime(wallSuperheatI);

            % equation from the thesis (based on DelValle & Kenning (1985)
            quenchingHeatFlux = waitTime * departureFrequency * quenchingArea * ...
                2 * liquidThermalConductivity * (wallSuperheatI + subcoolingTemperature) /...
                (sqrt(pi * waitTime * liquidThermalDiffusivity)); 

        else

            % equation from Mikic and Rohsenow
            quenchingHeatFlux = ((2 * liquidThermalConductivity) / sqrt(pi * liquidThermalDiffusivity)) * ...
                sqrt(departureFrequency) * (wallSuperheatI + subcoolingTemperature) * ...
                 quenchingArea; 

        end

        % Equation in Tu et al.
        % quenchingHeatFlux = (2/sqrt(pi)) * sqrt(liquidThermalDiffusivity) * ...
            % sqrt(departureFrequency) * quenchingArea * wallSuperheatI; 
    end

end