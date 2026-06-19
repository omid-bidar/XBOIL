function nucleationSite = nucleationSiteLi(wallSuperheatI)

    globalParams = getGlobalParams();

    caseDict = globalParams.caseDict;

    pressure = caseDict.pressure;   % in bar

    P_MPa = pressure * 0.1;

    fluidProperties = getFluidProperties(caseDict);

    saturationTemperature = fluidProperties.saturationTemperature;

    fP = 26.006 - 3.678 * exp(-2*P_MPa) - 21.907 * exp(-P_MPa/24.065); 

    A = -0.0002 * P_MPa^2 + 0.0108 * P_MPa + 0.0119;

    B = 0.122 * P_MPa + 1.988;

    N0 = 1e3;

    theta0 = deg2rad(41.37);

    Tc = 374; % temperature in Celsius

    Tc_K = Tc + 273.15;

    T0 = 25; % temperature in Celsius

    T0_K = T0 + 273.15;
    
    gamma = 0.719;

    % 1 - cos(theta)
    C = (1 - cos(theta0)) * ((Tc_K - saturationTemperature) / (Tc_K - T0_K))^gamma;

    nucleationSite = N0 * C * exp(fP) * wallSuperheatI^(A * wallSuperheatI + B); 

end
% Li, Q., Jiao, Y., Avramova, M., Chen, P., Yu, J., Chen, J., & Hou, J.
% (2018). Development, verification and application of a new model for
% active nucleation site density in boiling systems. Nuclear Engineering
% and Design, 328, 1?9. https://doi.org/10.1016/j.nucengdes.2017.12.027