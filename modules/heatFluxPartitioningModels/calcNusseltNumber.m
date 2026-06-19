function NusseltNumber = calcNusseltNumber(wallSuperheatI)
    
    global perturbedOverrides;

    if isfield(perturbedOverrides, 'NusseltNumber')
            
            NusseltNumber = perturbedOverrides.NusseltNumber(wallSuperheatI);
        
            return;

    end

    globalParams = getGlobalParams();

    convectiveModel = globalParams.convectiveModel;

    if convectiveModel == "Gnielinski"
        
        NusseltNumber = NusseltNumberGnielinski(wallSuperheatI); 
        
    elseif convectiveModel == "ChurchillAndChu"

        NusseltNumber = NusseltNumberChurchillAndChu(wallSuperheatI);
        
    elseif convectiveModel == "RanzMarshall"

        NusseltNumber = NusseltNumberRanzMarshall(wallSuperheatI); 

    elseif convectiveModel == "MarkatosAndPericleous"

        NusseltNumber = NusseltNumberMarkatosAndPericleous(wallSuperheatI); 
        
    else

        error("Invalide or no model selected to calculate the Nusselt number.")
    
    end 

end