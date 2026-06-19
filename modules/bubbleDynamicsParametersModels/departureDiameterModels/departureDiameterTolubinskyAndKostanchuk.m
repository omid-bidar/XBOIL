function departureDiameter = departureDiameterTolubinskyAndKostanchuk(wallSuperheatI)
    
    globalParams = getGlobalParams();

    caseDict = globalParams.caseDict;
    
    subcoolingTemeprature = caseDict.subcooling;

    departureDiameter = min(0.0014, 0.0006 * exp( - subcoolingTemeprature/ 45));

end
%Tolubinsky, V. I., & Kostanchuk, D. M. (1970). VAPOUR BUBBLES GROWTH RATE
%AND HEAT TRANSFER INTENSITY AT SUBCOOLED WATER BOILING. Proceeding of
%International Heat Transfer Conference 4.
%https://doi.org/10.1615/ihtc4.250