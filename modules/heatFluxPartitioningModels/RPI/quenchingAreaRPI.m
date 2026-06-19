function quenchingArea = quenchingAreaRPI(wallSuperheatI)

    if wallSuperheatI < 0

        quenchingArea = 1e-16;

    else 

        globalParams = getGlobalParams();
    
        fluidProperties = getFluidProperties(globalParams.caseDict); 
    
        departureDiameter = calcDepartureDiameter(wallSuperheatI);
    
        nucleationSiteDensity = calcNucleationSiteDensity(wallSuperheatI);
    
        JakobNumber = calcJakobNumber(wallSuperheatI, fluidProperties); 
    
        K = 4.8 * exp(-JakobNumber / 80);  % based on Tu and Yeoh
    
        quenchingArea = min(1, nucleationSiteDensity * K * pi * departureDiameter^2 / 4);

    end 

end 
% Kenning, D. B. R., & Del Valle M, V. H. (1981). Fully-developed nucleate
% boiling: Overlap of areas of influence and interference between bubble
% sites. International Journal of Heat and Mass Transfer, 24(6), 1025?1032.
% https://doi.org/10.1016/0017-9310(81)90133-2 Tu, J. Y., & Yeoh, G. H.
% (2002). On numerical modelling of low-pressure subcooled boiling flows.
% International Journal of Heat and Mass Transfer, 45(6), 1197?1209.
% https://doi.org/10.1016/s0017-9310(01)00230-7