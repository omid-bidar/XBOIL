function evaporationEffectiveArea = evaporationEffectiveAreaKimAndKim(wallSuperheatI)

    globalParams = getGlobalParams();

    contactAngleRadians = deg2rad(globalParams.caseDict.contactAngle); 

    departureDiameter = calcDepartureDiameter(wallSuperheatI); 

    nucleationSiteDensity = calcNucleationSiteDensity(wallSuperheatI); 
    
    Cm1 = effectiveAreaConstantKimAndKim(departureDiameter, nucleationSiteDensity);

    evaporationEffectiveArea = pi * (departureDiameter/2)^2 * (sin(contactAngleRadians))^2 * ...
        nucleationSiteDensity * Cm1; 

end 