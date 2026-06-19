function growthTime = growthTimeMIT(wallSuperheatI)

    growthFactor = calcBubbleGrowthConstant(wallSuperheatI);

    departureDiameter = calcDepartureDiameter(wallSuperheatI);

    growthTime = ( departureDiameter / (4 * growthFactor))^2;

end
% Kommajosyula, R. Development and assessment of a physics-based model for
% subcooled flow boiling with application to CFD. Diss. MIT, 2020.
