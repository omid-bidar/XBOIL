function fluidProperties = getFluidProperties(caseDict)

    fluid = caseDict.fluid; 

    subcoolingTemperature = caseDict.subcooling;

    pressurePascal = caseDict.pressure * 1e5;

    saturationTemperature = py.CoolProp.CoolProp.PropsSI('T', 'P', pressurePascal, 'Q', 0, fluid);
    
    fluidProperties.saturationTemperature = saturationTemperature; 
    
    fluidProperties.liquidDensity = py.CoolProp.CoolProp.PropsSI('D', 'T', saturationTemperature, 'Q', 0, fluid); 
    
    fluidProperties.gasDensity = py.CoolProp.CoolProp.PropsSI('D', 'T', saturationTemperature, 'Q', 1, fluid); 
    
    fluidProperties.liquidViscosity = py.CoolProp.CoolProp.PropsSI('V', 'T', saturationTemperature, 'Q', 0, fluid);
    
    fluidProperties.gasViscosity = py.CoolProp.CoolProp.PropsSI('V', 'T', saturationTemperature, 'Q', 1, fluid);

    fluidProperties.liquidSpecificHeatCapacity = py.CoolProp.CoolProp.PropsSI('C', 'T', saturationTemperature, 'Q', 0, fluid);
    
    fluidProperties.liquidThermalConductivity = py.CoolProp.CoolProp.PropsSI('L', 'T', saturationTemperature, 'Q', 0, fluid);  
    
    fluidProperties.latentHeat = py.CoolProp.CoolProp.PropsSI('H', 'T', saturationTemperature, 'Q', 1, fluid) - ...
           py.CoolProp.CoolProp.PropsSI('H', 'T', saturationTemperature, 'Q', 0, fluid); 
    
    fluidProperties.surfaceTension = py.CoolProp.CoolProp.PropsSI('SURFACE_TENSION', 'T', saturationTemperature, 'Q', 0, fluid);
    
    fluidProperties.liquidThermalExpansionCoefficient = py.CoolProp.CoolProp.PropsSI('ISOBARIC_EXPANSION_COEFFICIENT', 'T', saturationTemperature, 'Q', 0, fluid);

    fluidProperties.liquidThermalDiffusivity = fluidProperties.liquidThermalConductivity / ...
        (fluidProperties.liquidDensity * fluidProperties.liquidSpecificHeatCapacity);

end