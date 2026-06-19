function effectiveAreaConstant = effectiveAreaConstantKimAndKim(departureDiameter, nucleationSiteDensity)

    db = 1 / sqrt(nucleationSiteDensity);

    Rd = departureDiameter / 2;

    if db >= 2 * Rd

       Cm = 1;

    elseif db >= sqrt(2) * Rd && db < 2 * Rd

        Cm = 1 - 4 * ((1 / pi) * acos(db / (2 * Rd)) - (db / (2 * pi * Rd^2)) * sqrt(Rd^2 - (db^2 / 4)));

    elseif db < sqrt(2) * Rd

        Cm = db^2 / (pi * Rd^2);

    end

    effectiveAreaConstant = Cm; 

end 