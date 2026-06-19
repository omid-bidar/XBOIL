% runHFPDecomposition
%
% Decomposes the total wall heat flux into its constituent components for
% all three HFP models (RPI, MIT, KimAndKim) and plots the result.
%
% RPI / KimAndKim — three components:
%   q_evap   : evaporation
%   q_quench : quenching
%   q_conv   : single-phase convection
%
% MIT — four components:
%   q_evap   : evaporation (= micro layer + inception) 
%   q_quench : quenching (Pham et al. 2023)
%   q_slide  : sliding conduction
%   q_conv   : forced convection
%
% A single sub-model configuration is shared across all three HFP models
% so that differences in the decomposition are attributable to the HFP
% model alone, not to changes in the sub-models.
%
% Edit Section 1 (USER OPTIONS) to set the case and sub-model names.
% Run from the XBOIL root directory (where startupXBOIL.m lives).
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
plotResult = true;

% Best sub-model configuration per HFP model (from sweep results)
configs.RPI.departureDiameterModel  = "Ruckenstein";
configs.RPI.departureFrequencyModel = "Exact";
configs.RPI.nucleationSiteModel     = "LemmertChawla";
configs.RPI.waitTimeModel           = "MIT";
configs.RPI.growthTimeModel         = "VanStralen";
configs.RPI.convectiveModel         = "Gnielinski";

configs.MIT.departureDiameterModel  = "Phan";
configs.MIT.departureFrequencyModel = "Exact";
configs.MIT.nucleationSiteModel     = "WangDhir";
configs.MIT.waitTimeModel           = "MIT";
configs.MIT.growthTimeModel         = "Lee";
configs.MIT.convectiveModel         = "Gnielinski";

configs.KimAndKim.departureDiameterModel  = "VanStralenAndZijl";
configs.KimAndKim.departureFrequencyModel = "Zuber";
configs.KimAndKim.nucleationSiteModel     = "Li";
configs.KimAndKim.waitTimeModel           = "VanStralen";
configs.KimAndKim.growthTimeModel         = "Lee";
configs.KimAndKim.convectiveModel         = "Gnielinski";

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
% 4) COMPUTE DECOMPOSITION FOR EACH HFP MODEL
% -------------------------------------------------------------------------

HFPModels = {"RPI", "MIT", "KimAndKim"};
results   = struct();

for m = 1:numel(HFPModels)
    hfp = HFPModels{m};
    cfg = configs.(char(hfp));

    getGlobalParams(struct( ...
        'caseDict',                caseDict, ...
        'HFPModel',                hfp, ...
        'convectiveModel',         cfg.convectiveModel, ...
        'nucleationSiteModel',     cfg.nucleationSiteModel, ...
        'departureFrequencyModel', cfg.departureFrequencyModel, ...
        'departureDiameterModel',  cfg.departureDiameterModel, ...
        'waitTimeModel',           cfg.waitTimeModel, ...
        'growthTimeModel',         cfg.growthTimeModel, ...
        'growthConstantModel',     'Pham'));

    q_total  = zeros(nPoints, 1);
    q_evap   = zeros(nPoints, 1);
    q_quench = zeros(nPoints, 1);
    q_conv   = zeros(nPoints, 1);
    q_slide  = zeros(nPoints, 1);   % MIT only

    for p = 1:nPoints
        dT = wallSuperheats(p);

        q_total(p) = calcTotalHeatFlux(dT);

        if hfp == "RPI"
            q_evap(p)   = evaporationHeatFluxRPI(dT);
            q_quench(p) = quenchingHeatFluxRPI(dT);
            q_conv(p)   = convectionHeatFluxRPI(dT);

        elseif hfp == "MIT"
            q_evap(p)   = evaporationHeatFluxKommajosyula(dT);
            q_quench(p) = quenchingHeatFluxPham(dT);
            q_slide(p)  = slidingConductionHeatFluxKommajosyula(dT);
            q_conv(p)   = forcedConvectionHeatFluxKommajosyula(dT);

        elseif hfp == "KimAndKim"
            q_evap(p)   = evaporationHeatFluxKimAndKim(dT);
            q_quench(p) = quenchingHeatFluxKimAndKim(dT);
            q_conv(p)   = convectionHeatFluxKimAndKim(dT);
        end
    end

    r.total  = q_total;
    r.evap   = q_evap;
    r.quench = q_quench;
    r.conv   = q_conv;
    r.slide  = q_slide;
    results.(char(hfp)) = r;
end

% -------------------------------------------------------------------------
% 5) PRINT DECOMPOSITION TABLES
% -------------------------------------------------------------------------
for m = 1:numel(HFPModels)
    hfp = char(HFPModels{m});
    r   = results.(hfp);

    fprintf('\n--- %s ---\n', hfp);
    if strcmp(hfp, 'MIT')
        hdr = sprintf('  %8s  %12s  %12s  %12s  %12s  %12s', ...
            'dT (K)', 'q_total', 'q_evap', 'q_quench', 'q_slide', 'q_conv');
    else
        hdr = sprintf('  %8s  %12s  %12s  %12s  %12s', ...
            'dT (K)', 'q_total', 'q_evap', 'q_quench', 'q_conv');
    end
    sep = repmat('-', 1, numel(hdr));
    fprintf('%s\n%s\n', hdr, sep);

    for p = 1:nPoints
        if strcmp(hfp, 'MIT')
            fprintf('  %8.4f  %12.4e  %12.4e  %12.4e  %12.4e  %12.4e\n', ...
                wallSuperheats(p), r.total(p), r.evap(p), r.quench(p), r.slide(p), r.conv(p));
        else
            fprintf('  %8.4f  %12.4e  %12.4e  %12.4e  %12.4e\n', ...
                wallSuperheats(p), r.total(p), r.evap(p), r.quench(p), r.conv(p));
        end
    end
    fprintf('%s\n', sep);
end

% -------------------------------------------------------------------------
% 6) PLOT (OPTIONAL)
% -------------------------------------------------------------------------
if ~plotResult, return; end

colors = struct( ...
    'total',  [0.2  0.2  0.2], ...
    'evap',   [0.839 0.153 0.157], ...
    'quench', [0.122 0.471 0.706], ...
    'slide',  [0.173 0.627 0.173], ...
    'conv',   [0.580 0.404 0.741]);

fig = figure('Units', 'centimeters', 'Position', [2 2 24 8]);

for m = 1:numel(HFPModels)
    hfp = char(HFPModels{m});
    r   = results.(hfp);

    ax = subplot(1, 3, m);
    hold(ax, 'on');

    % Experimental
    plot(ax, wallSuperheats, expHeatFlux, 'ks', ...
        'MarkerFaceColor', 'none', 'MarkerSize', 7, 'LineWidth', 1.2, ...
        'DisplayName', 'Experimental');

    % Total predicted
    plot(ax, wallSuperheats, r.total, '-', ...
        'Color', colors.total, 'LineWidth', 2.0, ...
        'DisplayName', 'Total (predicted)');

    % Components
    plot(ax, wallSuperheats, r.evap, '--', ...
        'Color', colors.evap, 'LineWidth', 1.4, ...
        'DisplayName', 'Evaporation');
    plot(ax, wallSuperheats, r.quench, '--', ...
        'Color', colors.quench, 'LineWidth', 1.4, ...
        'DisplayName', 'Quenching');
    if strcmp(hfp, 'MIT')
        plot(ax, wallSuperheats, r.slide, '--', ...
            'Color', colors.slide, 'LineWidth', 1.4, ...
            'DisplayName', 'Sliding conduction');
    end
    plot(ax, wallSuperheats, r.conv, '--', ...
        'Color', colors.conv, 'LineWidth', 1.4, ...
        'DisplayName', 'Convection');

    title(ax, hfp, 'FontSize', 10);
    xlabel(ax, '\DeltaT_{wall} (K)', 'FontSize', 10);
    if m == 1
        ylabel(ax, 'q'' (W/m^2)', 'FontSize', 10);
    end
    legend(ax, 'Location', 'northwest', 'FontSize', 8);
    grid(ax, 'on'); box(ax, 'on');
end

sgtitle(sprintf('HFP decomposition — %s, %s', datasetName, caseLabel), 'FontSize', 11);
