function growthTime = growthTimeKommajosyula(wallSuperheatI)

    growthFactor = calcBubbleGrowthConstant(wallSuperheatI); 

    departureDiameter = calcDepartureDiameter(wallSuperheatI);

    growthTime = ( departureDiameter / (4 * growthFactor))^2;
    
end