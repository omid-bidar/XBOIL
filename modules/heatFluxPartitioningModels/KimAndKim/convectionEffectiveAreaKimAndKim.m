function convectionEffectiveArea = convectionEffectiveAreaKimAndKim(wallSuperheatI)

    % evaporationEffectiveArea = evaporationEffectiveAreaKimAndKim(wallSuperheatI);
    % 
    % quenchingEffectiveArea = quenchingEffectiveAreaKimAndKim(wallSuperheatI);
    % 
    % convectionEffectiveArea = max( 1 - evaporationEffectiveArea - quenchingEffectiveArea, 0);
    
    departureDiameter = calcDepartureDiameter(wallSuperheatI);

    nucleationSiteDensity = calcNucleationSiteDensity(wallSuperheatI);

    influenceAreaFactor = 1.4; 

    Cm2 = effectiveAreaConstantKimAndKim(influenceAreaFactor*departureDiameter, nucleationSiteDensity);

    convectionEffectiveArea = 1 - (pi * (influenceAreaFactor^2 * departureDiameter^2/4) * ...
        nucleationSiteDensity * Cm2);

    

end 