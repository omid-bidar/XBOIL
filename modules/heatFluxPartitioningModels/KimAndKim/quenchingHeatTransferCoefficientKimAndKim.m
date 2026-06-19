function quenchingHeatTransferCoefficient = quenchingHeatTransferCoefficientKimAndKim(wallSuperheatI)

    convectionHeatTransferCoefficient = convectionHeatTransferCoefficientKimAndKim(wallSuperheatI);

    quenchingHeatTransferCoefficient = 2 * convectionHeatTransferCoefficient; 

end 