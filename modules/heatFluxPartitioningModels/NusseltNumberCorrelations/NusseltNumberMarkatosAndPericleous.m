function NusseltNumber = NusseltNumberMarkatosAndPericleous(wallSuperheatI)

    RayleighNumber = calcRayleighNumber(wallSuperheatI);

    if RayleighNumber >= 1e3 && RayleighNumber <= 1e6 % Laminar
        
        NusseltNumber = 0.143 * RayleighNumber^0.299;

    elseif RayleighNumber > 1e6 && RayleighNumber <= 1e12 % Turbulent

        NusseltNumber = 0.082 * RayleighNumber^0.329; 

    elseif RayleighNumber > 1e12 && RayleighNumber <= 1e16 % Turbulent

        NusseltNumber = 1.325 * RayleighNumber^0.245;
    
    end 

end
% Markatos, N. C., & Pericleous, K. A. (1984). Laminar and turbulent
% natural convection in an enclosed cavity. International Journal of Heat
% and Mass Transfer, 27(5), 755?772.
% https://doi.org/10.1016/0017-9310(84)90145-5