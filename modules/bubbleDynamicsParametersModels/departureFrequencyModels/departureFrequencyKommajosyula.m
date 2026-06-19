function departureFrequency = departureFrequencyKommajosyula(wallSuperheatI) 

    growthTime = calcGrowthTime(wallSuperheatI);
    
    waitTime = calcWaitTime(wallSuperheatI);
    
    departureFrequency = 1 / (waitTime + growthTime);

end 
