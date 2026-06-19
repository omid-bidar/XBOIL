function nucleationSite = nucleationSiteLemmertChawla(wallSuperheatI)

    m = 185;
    
    p = 1.805;

    nucleationSite = (m * wallSuperheatI)^p;

end 
% Lemmert, M., & Chawla, L. M. (1974). Influence of flow velocity on
% surface boiling heat transfer coefficient. 1977.