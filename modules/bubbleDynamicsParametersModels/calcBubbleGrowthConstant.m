function growthConstant = calcBubbleGrowthConstant(wallSuperheatI)

    if wallSuperheatI < 0

        growthConstant = 0;

    else 

        globalParams = getGlobalParams();
    
        growthConstantModel = globalParams.growthConstantModel;
        
        if growthConstantModel == "Pham"
            
            growthConstant = bubbleGrowthConstantPham(wallSuperheatI);
    
        else
    
            error("No or invalid model for bubble growth constant.")
    
        end 

    end 
    
end 