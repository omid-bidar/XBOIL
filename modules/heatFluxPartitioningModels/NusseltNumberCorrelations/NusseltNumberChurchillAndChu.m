function NusseltNumber = NusseltNumberChurchillAndChu(wallSuperheatI)

    globalParams = getGlobalParams();

    caseDict = globalParams.caseDict;

    fluidProperties = getFluidProperties(caseDict);

    RayleighNumber = calcRayleighNumber(wallSuperheatI);

    PrandtlNumber = calcPrandtlNumber(fluidProperties); 

    NusseltNumber = (0.825 + 0.387 * RayleighNumber ^(1/6) / ...
        (1 + (0.492/PrandtlNumber)^(9/16))^(8/27))^2; 

end 
% Churchill, S. W., & Chu, H. H. S. (1975). Correlating equations for
% laminar and turbulent free convection from a vertical plate.
% International Journal of Heat and Mass Transfer, 18(11), 1323?1329.
% https://doi.org/10.1016/0017-9310(75)90243-4