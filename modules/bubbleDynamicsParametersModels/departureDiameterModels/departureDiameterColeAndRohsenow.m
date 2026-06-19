function departureDiameter = departureDiameterColeAndRohsenow(wallSuperheatI)

    globalParams = getGlobalParams();

    fluidProperties = getFluidProperties(globalParams.caseDict); 

    gasDensity = fluidProperties.gasDensity;

    liquidDensity = fluidProperties.liquidDensity;

    fluid = globalParams.caseDict.fluid;    

    if fluid == "Water"
        
        C = 1.5e-4;

    else 

        C = 4.65e-4;
        
    end 

    JakobNumber = calcJakobNumber(wallSuperheatI, fluidProperties);

    % JakobNumber = calcJakobNumber(globalParams.caseDict.subcooling, fluidProperties);

    surfaceTension = fluidProperties.surfaceTension;

    g   = 9.81;
    g_c = 1;   % gravitational conversion factor (SI)

    departureDiameter = C * JakobNumber^(5/4) * ...
        sqrt( (2 * surfaceTension * g_c) / (g * (liquidDensity - gasDensity)));

end
% Cole, R., & Rohsenow, W. M. (1969, September). Correlation of bubble
% departure diameters for boiling of saturated liquids. In Chem. Eng. Prog.
% Symp. Ser (Vol. 65, No. 92, pp. 211-213). 211 213.