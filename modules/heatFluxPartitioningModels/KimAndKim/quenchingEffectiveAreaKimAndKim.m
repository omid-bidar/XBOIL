function quenchingEffectiveArea = quenchingEffectiveAreaKimAndKim(wallSuperheatI)

    departureDiameter = calcDepartureDiameter(wallSuperheatI);

    nucleationSiteDensity = calcNucleationSiteDensity(wallSuperheatI);

    influenceAreaFactor = 1.4; 

    Cm2 = effectiveAreaConstantKimAndKim(influenceAreaFactor*departureDiameter, nucleationSiteDensity);

    evaporationEffectiveArea = evaporationEffectiveAreaKimAndKim(wallSuperheatI);

    quenchingEffectiveArea = pi * (influenceAreaFactor^2 * departureDiameter^2/4) * ...
        nucleationSiteDensity * Cm2 - evaporationEffectiveArea;

end 