function departureDiameter = calcDepartureDiameter(wallSuperheatI)

    global perturbedOverrides;

    % if wallSuperheatI < 0
    % 
    %     departureDiameter = 1e-16; 
    % 
    % else 

        if isfield(perturbedOverrides, 'departureDiameter')
            
            departureDiameter = perturbedOverrides.departureDiameter(wallSuperheatI);
        
            return;

        end
        
        globalParams = getGlobalParams(); 
    
        departureDiameterModel = globalParams.departureDiameterModel;
        
        if departureDiameterModel == "MIT"

            departureDiameter = departureDiameterMIT(wallSuperheatI);

        elseif departureDiameterModel == "Fritz"

            departureDiameter = departureDiameterFritz(wallSuperheatI);

        elseif departureDiameterModel == "Cole"
    
            departureDiameter = departureDiameterCole(wallSuperheatI); 
    
        elseif departureDiameterModel == "Ruckenstein" 
            
            departureDiameter = departureDiameterRuckenstein(wallSuperheatI);
    
        elseif departureDiameterModel == "VanStralenAndZijl"

            departureDiameter = departureDiameterVanStralenAndZijl(wallSuperheatI);

        elseif departureDiameterModel == "GolorinAndKolchugin"
            
            departureDiameter = departureDiameterGolorinAndKolchugin(wallSuperheatI); 
    
        elseif departureDiameterModel == "Kocamastafaogullari"
    
            departureDiameter = departureDiameterKocamastafaogullari(wallSuperheatI); 
    
        elseif departureDiameterModel == "ColeAndRohsenow"

            departureDiameter = departureDiameterColeAndRohsenow(wallSuperheatI);

        elseif departureDiameterModel == "KimAndKim"

            departureDiameter = departureDiameterKimAndKim(wallSuperheatI);
    
        elseif departureDiameterModel == "Phan"
    
            departureDiameter = departureDiameterPhan(wallSuperheatI); 
    
        elseif departureDiameterModel == "Nam"
    
            departureDiameter = departureDiameterNam(wallSuperheatI); 
    
        elseif departureDiameterModel == "Bovard"
    
            departureDiameter = departureDiameterBovard(wallSuperheatI); 
    
        elseif departureDiameterModel == "TolubinskyAndKostanchuk"

            departureDiameter = departureDiameterTolubinskyAndKostanchuk(wallSuperheatI);
            
        elseif departureDiameterModel == "ColomboAndFairweather"

            departureDiameter = departureDiameterColomboAndFairweather(wallSuperheatI);

        elseif departureDiameterModel == "Unal"

            departureDiameter = departureDiameterUnal(wallSuperheatI); 
        
        elseif departureDiameterModel == "Basu"

            departureDiameter = departureDiameterBasu(wallSuperheatI); 

        elseif departureDiameterModel == "Du"
            % this model is taken from Zhou et al. paper - based on
            % horizontal correlation of Du et al. original paper, Ja is
            % based on subcooling, but should be based on wall superheat.
            % Use DuHorizontal instead. 

            departureDiameter = departureDiameterDu(wallSuperheatI);

        elseif departureDiameterModel == "DuHorizontal"

            departureDiameter = departureDiameterDuHorizontal(wallSuperheatI);

        elseif departureDiameterModel == "DuVertical"

            departureDiameter = departureDiameterDuVertical(wallSuperheatI);
            
        elseif departureDiameterModel == "MoE"

            if isfield(globalParams, 'departureDiameterMoEFile') ...
                    && ~isempty(globalParams.departureDiameterMoEFile)
        
                departureDiameter = departureDiameterMoE( ...
                    wallSuperheatI, ...
                    globalParams.departureDiameterMoEFile);
        
            else
                
                departureDiameter = departureDiameterMoE(wallSuperheatI);
            end
            
        else
    
            error("Invalid departure diameter model. Check 'departureDiameterModel' variable is defined. e.g. departureDiameterModel = 'MIT'")
    
        end

    % end 

end
