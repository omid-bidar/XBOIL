function fluidProperties = getFluidProperties(caseDict)

fluid = caseDict.fluid; 

% subcoolingTemperature = caseDict.subcooling; 

pressurePascal = caseDict.pressure * 1e5; 

if strcmpi(fluid, 'FC-72')
    
    % FC-72 properties at 1 atm (from 3M Fluorinert FC-72 datasheet)

    fluidProperties.saturationTemperature = 56.0 + 273.15; % K
    
    fluidProperties.liquidDensity = 1680; % kg/m³
    
    fluidProperties.gasDensity = 13.3; % kg/m³ 
    
    fluidProperties.liquidViscosity = 0.638e-3; % Pa·s
    
    fluidProperties.gasViscosity = 12.6e-6; % Pa·s
    
    fluidProperties.liquidSpecificHeatCapacity = 1100; % J/kg/K
    
    fluidProperties.liquidThermalConductivity = 0.057; % W/m/K
    
    fluidProperties.latentHeat = 88e3; % J/kg
    
    fluidProperties.surfaceTension = 0.010; % N/m
    
    fluidProperties.liquidThermalExpansionCoefficient = 0.00156; % 1/K
    
else
    
    saturationTemperature = py.CoolProp.CoolProp.PropsSI('T', 'P', pressurePascal, 'Q', 0, fluid); 
    
    fluidProperties.saturationTemperature = saturationTemperature; 
    
    fluidProperties.liquidDensity = py.CoolProp.CoolProp.PropsSI('D', 'T', saturationTemperature, 'Q', 0, fluid); 
    
    fluidProperties.gasDensity = py.CoolProp.CoolProp.PropsSI('D', 'T', saturationTemperature, 'Q', 1, fluid); 
    
    fluidProperties.liquidViscosity = py.CoolProp.CoolProp.PropsSI('V', 'T', saturationTemperature, 'Q', 0, fluid); 
    
    fluidProperties.gasViscosity = py.CoolProp.CoolProp.PropsSI('V', 'T', saturationTemperature, 'Q', 1, fluid); 
        
    fluidProperties.liquidEnthalpy =  py.CoolProp.CoolProp.PropsSI('H', 'T', saturationTemperature, 'Q', 0 , fluid);
    
    fluidProperties.gasEnthalpy = py.CoolProp.CoolProp.PropsSI('H', 'T', saturationTemperature, 'Q', 1, fluid);

    fluidProperties.liquidSpecificHeatCapacity = py.CoolProp.CoolProp.PropsSI('C', 'T', saturationTemperature, 'Q', 0, fluid);

    fluidProperties.gasSpecificHeatCapacity = py.CoolProp.CoolProp.PropsSI('C', 'T', saturationTemperature, 'Q', 1, fluid);

    fluidProperties.liquidThermalConductivity = py.CoolProp.CoolProp.PropsSI('L', 'T', saturationTemperature, 'Q', 0, fluid);  
    
    fluidProperties.gasThermalConductivity = py.CoolProp.CoolProp.PropsSI('L', 'T', saturationTemperature, 'Q', 1, fluid);

    fluidProperties.latentHeat = py.CoolProp.CoolProp.PropsSI('H', 'T', saturationTemperature, 'Q', 1, fluid) - ...
        py.CoolProp.CoolProp.PropsSI('H', 'T', saturationTemperature, 'Q', 0, fluid); 
    
    fluidProperties.surfaceTension = py.CoolProp.CoolProp.PropsSI('SURFACE_TENSION', 'T', saturationTemperature, 'Q', 0, fluid); 
    
    fluidProperties.liquidThermalExpansionCoefficient = py.CoolProp.CoolProp.PropsSI('ISOBARIC_EXPANSION_COEFFICIENT', 'T', saturationTemperature, 'Q', 0, fluid);
    
end

fluidProperties.liquidThermalDiffusivity = fluidProperties.liquidThermalConductivity / ...
    (fluidProperties.liquidDensity * fluidProperties.liquidSpecificHeatCapacity);

end