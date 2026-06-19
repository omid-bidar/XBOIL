function nucleationSite = nucleationSiteHibikiIshiiKommajosyula(wallSuperheatI)

    globalParams = getGlobalParams; 

    departureFrequencyModel = globalParams.departureFrequencyModel;

    growthTimeModel = globalParams.growthTimeModel;

    N = nucleationSiteHibikiIshii(wallSuperheatI);

    t_growth = calcGrowthTime(wallSuperheatI);

    D_d = calcDepartureDiameter(wallSuperheatI); 

    f_bubble = calcDepartureFrequency(wallSuperheatI); 

    N0 = f_bubble * t_growth * pi * (D_d / 2)^2;

    if N0 * N < exp(-1)

        nucleationSite = N;

    elseif N0 * N > exp(-1) && N0 * N < exp(1)

        nucleationSite = (0.2689 * N0 * ...
            N + 0.2690) / N0;

    elseif N0 * N > exp(1)

        nucleationSite = (log(N0 * N) - log(log(N0 * N))) / N0;

    end
    
end 
% Kommajosyula, Ravikishore. Development and assessment of a physics-based
% model for subcooled flow boiling with application to CFD. Diss.
% Massachusetts Institute of Technology, 2020.