function growthTime = calcGrowthTime(wallSuperheatI)

    global perturbedOverrides;
    
    if wallSuperheatI < 0

        growthTime = 1e-16;

    else 

         if isfield(perturbedOverrides, 'growthTime')
            
            growthTime = perturbedOverrides.growthTime(wallSuperheatI);
        
            return;

        end

        globalParams = getGlobalParams(); 
    
        growthTimeModel = globalParams.growthTimeModel; 
    
        if growthTimeModel == "MIT"

            growthTime = growthTimeMIT(wallSuperheatI);
    
        elseif growthTimeModel == "VanStralen"

            growthTime = growthTimevanStralen(wallSuperheatI);
    
        elseif growthTimeModel == "Lee"
    
            growthTime = growthTimeLee(wallSuperheatI); 
    
        else
    
            error("Invalid or no model specified for calculating the bubble growth time.")
            
        end 

    end

end
