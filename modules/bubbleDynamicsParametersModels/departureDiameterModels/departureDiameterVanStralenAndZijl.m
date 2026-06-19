function departureDiameter = departureDiameterVanStralenAndZijl(wallSuperheatI)

    globalParams = getGlobalParams();

    fluidProperties = getFluidProperties(globalParams.caseDict); 

    JakobNumber = calcJakobNumber(wallSuperheatI, fluidProperties);

    % JakobNumber = calcJakobNumber(globalParams.caseDict.subcooling, fluidProperties);

    liquidThermalDiffusivity = fluidProperties.liquidThermalDiffusivity;

    g = 9.81;

    departureDiameter = 2.63 * ...
        ((JakobNumber^2 * liquidThermalDiffusivity^2 / g ))^(1/3) *...
        (1 + sqrt(2*pi)/ (3.*JakobNumber))^(1/4);

end 
% van Stralen, S. J. D., & Zijl, W. (1978). FUNDAMENTAL DEVELOPMENTS IN
% BUBBLE DYNAMICS. Proceeding of International Heat Transfer Conference 6.
% https://doi.org/10.1615/ihtc6.2600