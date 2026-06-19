function nucleationSite = calcNucleationSiteDensity(wallSuperheatI)

    global perturbedOverrides;
    
    if wallSuperheatI < 0

        nucleationSite = 1e-16; 
       
    else

         if isfield(perturbedOverrides, 'nucleationSiteDensity')
            
             nucleationSite = perturbedOverrides.nucleationSiteDensity(wallSuperheatI);
            
             return;
         end

        globalParams = getGlobalParams(); 
    
        nucleationSiteModel = globalParams.nucleationSiteModel;
    
        if nucleationSiteModel == "HibikiIshii"
    
            nucleationSite = nucleationSiteHibikiIshii(wallSuperheatI);
    
        elseif nucleationSiteModel == "HibikiIshiiMIT"

            nucleationSite = nucleationSiteHibikiIshiiMIT(wallSuperheatI);
    
        elseif nucleationSiteModel == "WangDhir"
            
            nucleationSite = nucleationSiteWangDhir(wallSuperheatI);
    
        elseif nucleationSiteModel == "LemmertChawla"
            
            nucleationSite = nucleationSiteLemmertChawla(wallSuperheatI);
    
        elseif nucleationSiteModel == "Li"
    
            nucleationSite = nucleationSiteLi(wallSuperheatI); 
    
        elseif nucleationSiteModel == "Yang"
    
            nucleationSite = nucleationSiteYang(wallSuperheatI); 

        elseif nucleationSiteModel == "Basu"

            nucleationSite = nucleationSiteBasu(wallSuperheatI);

        elseif nucleationSiteModel == "KocamustafaogullariAndIshii"

            nucleationSite = nucleationSiteKocamustafaogullariAndIshii(wallSuperheatI);

        elseif nucleationSiteModel == "MoE"
    
            nucleationSite = nucleationSiteMoE(wallSuperheatI); 

        elseif nucleationSiteModel == "MoE_v1"

            nucleationSite = nucleationSiteMoE_v1(wallSuperheatI); 
    
        else
    
            error("Invalid or no nucleation site model defined.")
    
        end

    end 

end
