% runSingleConfig
%
% Runs XBOIL for a single, user-specified model configuration and compares
% the predicted boiling curve against experimental data.
%
%   - Prints a point-by-point table: q_pred, q_exp, Dd, f, Nb, tw, tg
%   - Reports MAPE and MSE for the configuration
%   - Optionally plots the boiling curve
%
% Edit Section 1 (USER OPTIONS) to set the case and sub-model names.
% Run from any directory — paths are resolved relative to this file.
%
% See tutorials/README.md for a full explanation of every option.
%
% Reference:
%   O. Bidar and M. Colombo, "Evaluations of boiling heat flux partitioning
%   and bubble parameter models using a 0-D framework,"
%   Int. J. Heat Mass Transfer 269 (2026) 129059.
%   https://doi.org/10.1016/j.ijheatmasstransfer.2026.129059
%
% --------------------------------------------------------------------------

clc; clear; close all;

% -------------------------------------------------------------------------
% 1) USER OPTIONS — edit here
% -------------------------------------------------------------------------
datasetName = 'Phillips';
caseLabel  = 'case1';
plotResult = true;      % set false to suppress the boiling curve plot

config.HFPModel                = "RPI";
config.departureDiameterModel  = "Ruckenstein";
config.departureFrequencyModel = "Exact";        % "Exact" = f = 1/(tg+tw) by definition
config.nucleationSiteModel     = "LemmertChawla";
config.waitTimeModel           = "MIT";
config.growthTimeModel         = "VanStralen";
config.convectiveModel         = "Gnielinski";

% -------------------------------------------------------------------------
% 2) STARTUP
% -------------------------------------------------------------------------
if ~exist('calcTotalHeatFlux', 'file')
    if exist('startupXBOIL.m', 'file')
        run('startupXBOIL.m');
    else
        error('startupXBOIL.m not found. Run this script from the XBOIL root directory.');
    end
end

% -------------------------------------------------------------------------
% 3) LOAD EXPERIMENTAL DATA
% -------------------------------------------------------------------------
dataFile = fullfile('data', [datasetName '.mat']);
if ~exist(dataFile, 'file')
    error('Data file not found: %s\nRun this script from the XBOIL root directory.', dataFile);
end
S = load(dataFile);
caseDict = S.(datasetName).(caseLabel);

expData        = caseDict.totalHeatFluxExperiment;
wallSuperheats = expData(expData(:,1) >= 0, 1);
expHeatFlux    = expData(expData(:,1) >= 0, 2);
nPoints        = numel(wallSuperheats);

% -------------------------------------------------------------------------
% 4) INITIALISE GLOBAL STATE AND RUN
% -------------------------------------------------------------------------
getGlobalParams(struct( ...
    'caseDict',                caseDict, ...
    'HFPModel',                config.HFPModel, ...
    'convectiveModel',         config.convectiveModel, ...
    'nucleationSiteModel',     config.nucleationSiteModel, ...
    'departureFrequencyModel', config.departureFrequencyModel, ...
    'departureDiameterModel',  config.departureDiameterModel, ...
    'waitTimeModel',           config.waitTimeModel, ...
    'growthTimeModel',         config.growthTimeModel, ...
    'growthConstantModel',     'Pham'));

totalHeatFlux         = zeros(nPoints, 1);
departureDiameter     = zeros(nPoints, 1);
departureFrequency    = zeros(nPoints, 1);
nucleationSiteDensity = zeros(nPoints, 1);
waitTime              = zeros(nPoints, 1);
growthTime            = zeros(nPoints, 1);

for p = 1:nPoints
    dT = wallSuperheats(p);
    totalHeatFlux(p)         = calcTotalHeatFlux(dT);
    departureDiameter(p)     = calcDepartureDiameter(dT);
    departureFrequency(p)    = calcDepartureFrequency(dT);
    nucleationSiteDensity(p) = calcNucleationSiteDensity(dT);
    waitTime(p)              = calcWaitTime(dT);
    growthTime(p)            = calcGrowthTime(dT);
end

% -------------------------------------------------------------------------
% 5) ERROR METRICS
% -------------------------------------------------------------------------
mse  = mean((totalHeatFlux - expHeatFlux).^2);
mape = 100 * mean(abs(totalHeatFlux - expHeatFlux) ./ abs(expHeatFlux));

% -------------------------------------------------------------------------
% 6) PRINT RESULTS
% -------------------------------------------------------------------------
fprintf('\nCase: %s\n', caseLabel);
fprintf('  Flow conditions:\n');
flowFields = {'fluid','pressure','velocity','massFlux','subcooling', ...
              'hydraulicDiameter','referenceLength','contactAngle'};
flowUnits  = {'','bar','m/s','kg/m^2/s','K','m','m','deg'};
flowFmt    = {'%s','%.2f','%.4f','%.2f','%.2f','%.4e','%.4e','%.2f'};
for i = 1:numel(flowFields)
    if isfield(caseDict, flowFields{i})
        val = caseDict.(flowFields{i});
        if ischar(val) || isstring(val)
            fprintf('    %-22s: %s\n', flowFields{i}, val);
        else
            fprintf(['    %-22s: ' flowFmt{i} ' %s\n'], flowFields{i}, val, flowUnits{i});
        end
    end
end
fprintf('  Heater properties:\n');
heaterFields = {'heaterMaterial','heaterDensity','heaterSpecificHeatCapacity', ...
                'heaterThermalDiffusivity','heaterThermalConductivity'};
heaterUnits  = {'','kg/m^3','J/kg.K','m^2/s','W/m.K'};
heaterFmt    = {'%s','%.2f','%.2e','%.6e','%.2e'};
for i = 1:numel(heaterFields)
    if isfield(caseDict, heaterFields{i})
        val = caseDict.(heaterFields{i});
        if ischar(val) || isstring(val)
            fprintf('    %-30s: %s\n', heaterFields{i}, val);
        else
            fprintf(['    %-30s: ' heaterFmt{i} ' %s\n'], heaterFields{i}, val, heaterUnits{i});
        end
    end
end

fprintf('\nConfiguration\n');
fprintf('  HFP model      : %s\n', config.HFPModel);
fprintf('  Departure diam.: %s\n', config.departureDiameterModel);
fprintf('  Departure freq.: %s\n', config.departureFrequencyModel);
fprintf('  Nucleation site: %s\n', config.nucleationSiteModel);
fprintf('  Wait time      : %s\n', config.waitTimeModel);
fprintf('  Growth time    : %s\n', config.growthTimeModel);
fprintf('  Convection     : %s\n\n', config.convectiveModel);

hdr = sprintf('  %8s  %12s  %12s  %12s  %12s  %12s  %12s  %12s', ...
    'dT (K)', 'q_pred', 'q_exp', 'Dd (m)', 'f (Hz)', 'Nb (1/m2)', 'tw (s)', 'tg (s)');
sep = repmat('-', 1, numel(hdr));
fprintf('%s\n%s\n', hdr, sep);
for p = 1:nPoints
    fprintf('  %8.4f  %12.4e  %12.4e  %12.4e  %12.4e  %12.4e  %12.4e  %12.4e\n', ...
        wallSuperheats(p), totalHeatFlux(p), expHeatFlux(p), ...
        departureDiameter(p), departureFrequency(p), nucleationSiteDensity(p), ...
        waitTime(p), growthTime(p));
end
fprintf('%s\n', sep);
fprintf('  MSE  = %.4e (W/m^2)^2\n', mse);
fprintf('  MAPE = %.2f %%\n\n', mape);

% -------------------------------------------------------------------------
% 7) PLOT (OPTIONAL)
% -------------------------------------------------------------------------
if plotResult
    figure('Units', 'centimeters', 'Position', [4 4 16 12]);
    plot(wallSuperheats, expHeatFlux, 'ks', ...
        'MarkerFaceColor', 'none', 'MarkerSize', 7, ...
        'DisplayName', 'Experimental', 'LineWidth', 2);
    hold on;
    plot(wallSuperheats, totalHeatFlux, '-o', ...
        'Color', [0.122 0.471 0.706], 'LineWidth', 1.8, 'MarkerSize', 5, ...
        'DisplayName', sprintf('%s prediction', config.HFPModel));
    xlabel('Wall Superheat, \DeltaT_{wall} (K)', 'FontSize', 11);
    ylabel('Total Heat Flux, q_{total} (W/m^2)',  'FontSize', 11);
    title(sprintf('Boiling curve for %s dataset — %s', datasetName, caseLabel), 'FontSize', 10);
    legend('Location', 'northwest', 'FontSize', 9);
    grid on; box on;
    note = sprintf('MAPE = %.1f%%\nMSE = %.2e', mape, mse);
    text(0.97, 0.05, note, 'Units', 'normalized', ...
        'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom', ...
        'FontSize', 9, 'BackgroundColor', [1 1 1 0.8], 'Interpreter', 'none');
end
