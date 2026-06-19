function nucleationSite = nucleationSiteHibikiIshii(wallSuperheatI)

    globalParams = getGlobalParams();

    caseDict = globalParams.caseDict;

    fluidProperties = getFluidProperties(caseDict);

    T_sat = fluidProperties.saturationTemperature;

    deltaT_sup = wallSuperheatI; 

    h_fg = fluidProperties.latentHeat;

    sigma = fluidProperties.surfaceTension;

    rho_g = fluidProperties.gasDensity;

    rho_f = fluidProperties.liquidDensity; 

    P = caseDict.pressure * 1e5;        % assume in bar, so convert to Pascals.

    % constant parameters
    N_bar = 4.72e5;             % Reference nucleation site density (sites/m^2)

    mu = 0.722;                 % Wettability parameter (rad)

    lambda_prime = 2.50e-6;     % Cavity length scale (m)

    R_g = 461.52;               % Specific gas constant for water (J/kgK)

    theta = caseDict.contactAngle; 

    theta_rad = deg2rad(theta);

    T_w = T_sat + deltaT_sup; 

    exponent_term = exp((h_fg * deltaT_sup) / (R_g * T_sat * T_w)) - 1;

    Rc = 2 * sigma * (1 + rho_g / rho_f) / (P * exponent_term);

    rho_plus = log10((rho_f - rho_g) / rho_g);

    f_rho_plus = -0.01064 + 0.48246 * rho_plus - 0.22712 * rho_plus^2 + 0.05468 * rho_plus^3;
    
    nucleationSite = N_bar * (1 - exp(-theta_rad^2 / (8 * mu^2))) * (exp(f_rho_plus * lambda_prime / Rc) - 1);

end 
% Hibiki, Takashi, and Mamoru Ishii. "Active nucleation site density in
% boiling systems." International Journal of Heat and Mass Transfer 46.14
% (2003): 2587-2601.
