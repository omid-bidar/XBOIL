function PrandtlNumber = calcPrandtlNumber(fluidProperties)

    viscosity = fluidProperties.liquidViscosity;    

    specificHeatCapacity = fluidProperties.liquidSpecificHeatCapacity;

    thermalConductivity = fluidProperties.liquidThermalConductivity; 

    PrandtlNumber = (viscosity * specificHeatCapacity) / thermalConductivity; 
    
end
