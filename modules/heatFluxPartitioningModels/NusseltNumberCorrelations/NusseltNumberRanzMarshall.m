function NusseltNumber = NusseltNumberRanzMarshall(wallSuperheatI)

    globalParams = getGlobalParams();

    fluidProperties = getFluidProperties(globalParams.caseDict);

    ReynoldsNumber = calcReynoldsNumber(fluidProperties);

    PrandtlNumber = calcPrandtlNumber(fluidProperties);

    NusseltNumber = 2 + 0.6 * ReynoldsNumber^0.5 * PrandtlNumber^0.3;

end 