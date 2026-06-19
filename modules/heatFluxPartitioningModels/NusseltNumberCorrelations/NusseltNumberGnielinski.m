function NusseltNumber = NusseltNumberGnielinski(wallSuperheatI)
    
    globalParams = getGlobalParams();

    caseDict = globalParams.caseDict;

    fluidProperties = getFluidProperties(caseDict);

    Re = calcReynoldsNumber(fluidProperties);

    Pr = calcPrandtlNumber(fluidProperties);

    epsilon = caseDict.surfaceRoughness; 

    D_h = caseDict.referenceLength;

    func = @(f) 1/sqrt(f) + 2*log10(epsilon/(3.7*D_h) + 2.51/(Re*sqrt(f)));
    % Suppress the output to the command window after equation is solved
    options = optimoptions('fsolve', 'Display', 'off');
    initialGuess = 0.01; 
    
    f = fsolve(func, initialGuess, options);

    NusseltNumber = ((f/8) * (Re - 1000) * Pr) / (1 + 12.7 * sqrt(f/8) * (Pr^(2/3) - 1));

end
% V. Gnielinski, “New equations for heat and mass transfer in turbulent
% pipe and channel flow,” Int. Chem. Eng., vol. 16, no. 2, pp. 359–368,
% 1976.