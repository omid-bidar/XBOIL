function dd = departureDiameterColomboAndFairweather(wallSuperheat)

caseDict = getGlobalParams().caseDict;
% Constants
dt = 1e-5;
dw = 9e-5; % bubble contact diameter

subcooling = "Mazzocco";
if caseDict.velocity == 0
    flowType = "pool";
else
    flowType = "flow";
end

fluidProperties = getFluidProperties(caseDict);

prop = zeros(1, 15);
prop(1)  = fluidProperties.liquidDensity;
prop(2)  = fluidProperties.gasDensity;
prop(3)  = fluidProperties.liquidViscosity;
prop(4)  = fluidProperties.gasViscosity;
prop(5)  = fluidProperties.liquidEnthalpy;
prop(6)  = fluidProperties.gasEnthalpy;
prop(7)  = fluidProperties.liquidThermalConductivity;
prop(8)  = fluidProperties.gasThermalConductivity;
prop(9)  = fluidProperties.liquidSpecificHeatCapacity;
prop(10) = fluidProperties.gasSpecificHeatCapacity;
prop(11) = fluidProperties.surfaceTension;
prop(12) = fluidProperties.liquidThermalDiffusivity;
% need the following two variables for the original departure diameter
% datasets from Colombo & Fairweather
if isfield(caseDict, 'PrandtlSubcooling')
    prop(14) = caseDict.PrandtlSubcooling;
end
if isfield(caseDict, 'ReL')
    prop(13) = caseDict.ReL;
end

prop(15) = calcPrandtlNumber(fluidProperties);

% Extract data
saturationTemperature = caseDict.saturationTemperatureLiquid;
% wallSuperheat% K
wallTemperature = wallSuperheat + saturationTemperature; % K
data = zeros(1, 21);
data(4) = caseDict.hydraulicDiameter;
data(5) = caseDict.pressure;
data(6) = saturationTemperature - 273.15; % Convert to Celsius for compatibility
data(7) = caseDict.velocity;
data(9) = caseDict.subcooling;
data(11) = wallTemperature - 273.15; % wall temperature in Celsius
data(17) = caseDict.channelOrientation;
if isfield(caseDict, "heatFlux")
    data(10) = caseDict.heatFlux;
end

Dh = data(4);
psys = data(5);
Tsat = data(6);
Ub = data(7);
dTSUB = data(9);
Tb = Tsat - dTSUB;
Twall = data(11);
tetaHor = data(17);

% Initialisation
t = dt;
F = -ones(1,12);
count = 0;
r = 0;
dd = 0;
dlo = 0;
old = 1;

% WALL TEMPERATURE AND PROFILE RATIO CALCULATION
if strcmp(flowType, 'flow')
    f = [1,1,1,1,1,0,0];
    [Tw, ratio, dT] = TwChen(data, prop);
elseif strcmp(flowType, 'pool')
    f = [1,1,0,0,1,0,0];
    [dT, delta, h] = wallLayerPool(data, prop, poolHeatTransfer);
else
    error('Unknown flowType');
end

% MICROLAYER CONTRIBUTION
micro = microlayerCLLeeds(prop, dT);
dry = dryFraction(F(11), data, r);
A = dry * micro;
while F(12) < 0
    % SUBCOOLED AND SUPER-HEATING CONTRIBUTION
    if strcmp(flowType, 'flow')
        [r, r1, r2, Tsh, SH, B, SUB] = bubbleGrowth2025(data, prop, r, t, dt, Tw, ratio, A, subcooling);
        F = forceCalculation(F(11), data, prop, r, r1, r2, f);
    elseif strcmp(flowType, 'pool')
        Tsh = poolT(data, r, delta);
        SH = superheatingPZ(data, prop, Tsh);
        [r, r1, r2] = bubbleGrowthCF2018Integral(t, dt, A, SH, r);
        F = forceCalculationPool(F(11), data, prop, r, r1, r2, f);
    end

    % Stop if dr < 0
    if r1 < 0
        solution = 'negative dr';
        break
    end

    count = count + 1;

    % Check for tangential force sign change
    if F(11) > 0 && old < 0
        dd = 2 * r;
        Fd = F;
        solution = 'departure';
    end

    old = F(11);

    % Break if too many iterations
    if count >= 1e6
        solution = 'Mechanistic departure diameter: iteration limit.';
        warning(solution);
        break
    end

    t = t + dt;
end

% Lift-off
dlo = 2 * r;
Flo = F;

if dd == 0
    dd = dlo;
    Fd = F;
    if F(12) > 0
        solution = 'departure';
    end
end

end
