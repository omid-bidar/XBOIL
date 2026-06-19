function nucleationSite = nucleationSiteBasu(wallSuperheatI)

    caseDict = getGlobalParams().caseDict; 

    contactAngle = caseDict.contactAngle;

    if wallSuperheatI < 15
        
        nucleationSite = 0.34e4 * (1 - cos(deg2rad(contactAngle))) * ...
                wallSuperheatI^2;

    elseif wallSuperheatI >= 15
        
        nucleationSite = 3.4e-1 * (1 - cos(deg2rad(contactAngle))) * ...
                wallSuperheatI^5.3;
    
    end 

end 
% N. Basu, G.R. Warrier, V.K. Dhir, Onset of nucleate boiling and active nucleation
% site density during subcooled flow boiling, J. Heat Transfer 124 (4) (2002) 717–728