function waitTime = calcWaitTime(wallSuperheatI)

    global perturbedOverrides;

    if wallSuperheatI < 0

        waitTime = 1e-16;
        
    else 

        if isfield(perturbedOverrides, 'waitTime')
            
            waitTime = perturbedOverrides.waitTime(wallSuperheatI);
        
            return;

        end

        globalParams = getGlobalParams(); 
    
        waitTimeModel = globalParams.waitTimeModel; 
    
        if waitTimeModel == "MIT"

            waitTime = waitTimeMIT(wallSuperheatI);

        elseif waitTimeModel == "VanStralen"

            waitTime = waitTimeVanStralen(wallSuperheatI);
    
        else
    
            error("Invalid or no model specified for calculating the wait time.")
    
        end 
        
    end
    
end
