function departureDiameter = departureDiameterFritz(wallSuperheatI)

    globalParams = getGlobalParams();

    caseDict = globalParams.caseDict;

    fluidProperties = getFluidProperties(caseDict);

    surfaceTension = fluidProperties.surfaceTension;

    liquidDensity = fluidProperties.liquidDensity;

    gasDensity = fluidProperties.gasDensity;

    contactAngle = caseDict.contactAngle;

    gravity = 9.81;

    departureDiameter = 0.0208 * contactAngle *...
        sqrt(...
        surfaceTension / ...
        (gravity * (liquidDensity - gasDensity)));

end
% Fritz, W. "Maximum volume of vapor bubbles." Physic. Zeitschz. 36 (1935):
% 379-354.
