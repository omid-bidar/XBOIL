function departureFrequency = calcDepartureFrequency(wallSuperheatI)

    global perturbedOverrides;

    if wallSuperheatI < 0

        departureFrequency = 1e-16;

    else 

         if isfield(perturbedOverrides, 'departureFrequency')
            
            departureFrequency = perturbedOverrides.departureFrequency(wallSuperheatI);
        
            return;

        end

        globalParams = getGlobalParams(); 
    
        departureFrequencyModel = globalParams.departureFrequencyModel; 
    
        if departureFrequencyModel == "Kommajosyula"
    
            departureFrequency = departureFrequencyKommajosyula(wallSuperheatI);
    
        elseif departureFrequencyModel == "Exact"

            departureFrequency = departureFrequencyKimAndKim(wallSuperheatI);
    
        elseif departureFrequencyModel == "Cole"
    
            departureFrequency = departureFrequencyCole(wallSuperheatI); 
    
        elseif departureFrequencyModel == "PeeblesAndGarber"
    
            departureFrequency = departureFrequencyPeeblesAndGarber(wallSuperheatI); 
    
        elseif departureFrequencyModel == "SakashitaAndOno"
    
            departureFrequency = departureFrequencySakashitaAndOno(wallSuperheatI); 
    
        elseif departureFrequencyModel == "Stephan"
    
            departureFrequency = departureFrequencyStephan(wallSuperheatI); 
    
        elseif departureFrequencyModel == "Zuber"
    
            departureFrequency = departureFrequencyZuber(wallSuperheatI);
    
        elseif departureFrequencyModel == "BrooksAndHibiki"
    
            departureFrequency = departureFrequencyBrooksAndHibiki(wallSuperheatI); 
    
        else
    
            error("Invalid or no model specified for calculating the departure frequency.")
    
        end 

    end     
    
end
