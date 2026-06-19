function growthConstant = bubbleGrowthConstantPham(wallSuperheatI)
    % Bubble growth constant (based on Pham et al. 2023) 

    globalParams = getGlobalParams();

    caseDict = globalParams.caseDict;

    fluidProperties = getFluidProperties(caseDict); 

    PrandtlNumber = calcPrandtlNumber(fluidProperties);

    JakobNumberSuperheat = calcJakobNumber(wallSuperheatI, fluidProperties);

    thermalDiffusivity = fluidProperties.liquidThermalConductivity / ...
                        (fluidProperties.liquidDensity * fluidProperties.liquidSpecificHeatCapacity); 

    subcoolingTemperature = caseDict.subcooling; 

    growthConstant = JakobNumberSuperheat * sqrt(thermalDiffusivity) * ...
        (...
            1.243 / sqrt(PrandtlNumber) - ...
            min( ...
                0.5 * 1.243 / sqrt(PrandtlNumber),...
                0.0977 * subcoolingTemperature / wallSuperheatI...
            )...
         );

end