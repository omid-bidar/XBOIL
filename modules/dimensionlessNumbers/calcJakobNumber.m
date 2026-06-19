function JakobNumber = calcJakobNumber(temperature, fluidProperties)

    liquidDensity = fluidProperties.liquidDensity;

    gasDensity = fluidProperties.gasDensity;

    liquidSpecificHeatCapacity = fluidProperties.liquidSpecificHeatCapacity; 

    latentHeat = fluidProperties.latentHeat;
   
    JakobNumber = (liquidDensity * liquidSpecificHeatCapacity * temperature) ...
                    / (gasDensity * latentHeat);    
    
end 
