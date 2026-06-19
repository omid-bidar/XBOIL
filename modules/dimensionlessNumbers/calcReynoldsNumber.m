function ReynoldsNumber = calcReynoldsNumber(fluidProperties)

    globalParams = getGlobalParams();

    caseDict = globalParams.caseDict; 

    hydraulicDiameter = caseDict.hydraulicDiameter; 

    liquidDensity = fluidProperties.liquidDensity;

    liquidViscosity = fluidProperties.liquidViscosity;
    
    velocity = caseDict.velocity;

    ReynoldsNumber = (liquidDensity * velocity * hydraulicDiameter) / ...
        liquidViscosity; 
    
end 