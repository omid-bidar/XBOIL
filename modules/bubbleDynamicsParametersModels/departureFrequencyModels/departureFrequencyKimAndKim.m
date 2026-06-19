function departureFrequency = departureFrequencyKimAndKim(wallSuperheatI)

    growthTime = calcGrowthTime(wallSuperheatI);

    departureFrequency = 1 / (growthTime + 3 * growthTime); 

end 