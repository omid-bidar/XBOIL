function D_dry_by_D_ml = calcD_dry_by_D_ml(wallSuperheatI)

    globalParams = getGlobalParams();

    caseDict = globalParams.caseDict;

    fluidProperties = getFluidProperties(caseDict);

    CapillaryNumber = calcCapillaryNumber(wallSuperheatI); 

    contactAngle = caseDict.contactAngle; 

    D_dry_by_D_ml = max( ...
                        0.1237 * CapillaryNumber^(-0.373) * sind(contactAngle), ...
                        1 ...
                        );

end 