% postProcessPhillips
%
% Post-processes sweep results from runSweepPhillips.m.
%
%   - Ranks all configurations by MSE against experimental data
%   - Plots boiling curves for the best configuration per HFP model
%   - Displays the top 10 configurations overall with MAPE
%
% Run from the XBOIL root directory.
% --------------------------------------------------------------------------

clc; clear; close all;

% -------------------------------------------------------------------------
% 1) USER OPTIONS
% -------------------------------------------------------------------------
datasetName = 'Phillips';
caseLabel  = 'case1';
resultsDir = fullfile('results', [datasetName '_' caseLabel]);
dataFile   = fullfile('data', [datasetName '.mat']);
topN       = 10;     % configurations to show in the ranking table
HFPOrder   = ["RPI", "MIT", "KimAndKim"];   % subplot order

% -------------------------------------------------------------------------
% 2) LOAD DATA
% -------------------------------------------------------------------------
if ~exist(dataFile, 'file')
    error('Data file not found: %s', dataFile);
end
S = load(dataFile);
caseDict = S.(datasetName).(caseLabel);

expData        = caseDict.totalHeatFluxExperiment;
wallSuperheats = expData(expData(:,1) >= 0, 1);
expHeatFlux    = expData(expData(:,1) >= 0, 2);
nPoints        = numel(wallSuperheats);

resultFile = fullfile(resultsDir, 'allModelResults.mat');
if ~exist(resultFile, 'file')
    error('Results file not found: %s\nRun runSweepPhillips.m first.', resultFile);
end
load(resultFile, 'existingData');
nConfigs = numel(existingData.results);
fprintf('Loaded %d configurations from %s\n', nConfigs, resultFile);

% -------------------------------------------------------------------------
% 3) COMPUTE MSE AND MAPE FOR ALL CONFIGURATIONS
% -------------------------------------------------------------------------
mseAll  = zeros(nConfigs, 1);
mapeAll = zeros(nConfigs, 1);

for i = 1:nConfigs
    q = existingData.results{i}.totalHeatFlux(:);
    mseAll(i)  = mean((q - expHeatFlux).^2);
    mapeAll(i) = 100 * mean(abs(q - expHeatFlux) ./ abs(expHeatFlux));
end

% -------------------------------------------------------------------------
% 4) RANK CONFIGURATIONS (by MSE)
% -------------------------------------------------------------------------
[~, rankIdx] = sort(mseAll, 'ascend');

% -------------------------------------------------------------------------
% 5) PRINT TOP-N TABLE
% -------------------------------------------------------------------------
fprintf('\n');
hdr = sprintf(' %4s  %11s  %7s  %-10s  %-23s  %-18s  %-18s  %-12s  %-12s  %-15s', ...
    'Rank', 'MSE', 'MAPE(%)', 'HFP', 'Dd', 'freq', 'Nb', 'tw', 'tg', 'Nu');
fprintf('\n%s\n%s\n', hdr, repmat('-', 1, numel(hdr)));

for k = 1:topN
    idx = rankIdx(k);
    cfg = existingData.configurations{idx};
    fprintf(' %4d  %11.4e  %7.2f  %-10s  %-23s  %-18s  %-18s  %-12s  %-12s  %-15s\n', ...
        k, mseAll(idx), mapeAll(idx), ...
        char(cfg.HFPModel), char(cfg.departureDiameterModel), ...
        char(cfg.departureFrequencyModel), char(cfg.nucleationSiteModel), ...
        char(cfg.waitTimeModel), char(cfg.growthTimeModel), char(cfg.convectiveModel));
end
fprintf('\n');

% -------------------------------------------------------------------------
% 6) FIND BEST CONFIGURATION PER HFP
% -------------------------------------------------------------------------
bestIdx  = struct();
bestCfg  = struct();
bestMSE  = struct();
bestMAPE = struct();
bestPred = struct();

for h = 1:numel(HFPOrder)
    hfp  = char(HFPOrder(h));
    hfpMask = cellfun(@(c) strcmp(char(c.HFPModel), hfp), existingData.configurations);
    hfpIdx  = find(hfpMask);
    if isempty(hfpIdx)
        error('No configurations found for HFP model "%s".', hfp);
    end
    [~, localBest] = min(mseAll(hfpIdx));
    bi = hfpIdx(localBest);
    bestIdx.(hfp)  = bi;
    bestCfg.(hfp)  = existingData.configurations{bi};
    bestMSE.(hfp)  = mseAll(bi);
    bestMAPE.(hfp) = mapeAll(bi);
    bestPred.(hfp) = existingData.results{bi}.totalHeatFlux(:);
end

% -------------------------------------------------------------------------
% 7) PLOT BOILING CURVES
% -------------------------------------------------------------------------
colors = [0.122 0.471 0.706;   % blue  — RPI
          0.200 0.627 0.173;   % green — MIT
          0.890 0.102 0.110];  % red   — KimAndKim

fig = figure('Units','centimeters','Position',[2 2 36 12]);
tiledlayout(1, numel(HFPOrder), 'TileSpacing','compact', 'Padding','compact');

for h = 1:numel(HFPOrder)
    hfp = char(HFPOrder(h));
    ax  = nexttile;

    % Experimental data
    plot(ax, wallSuperheats, expHeatFlux, 'ks', ...
        'MarkerFaceColor', 'none', 'MarkerSize', 7, ...
        'DisplayName', 'Experimental', 'LineWidth', 2);
    hold(ax, 'on');

    % Best prediction
    plot(ax, wallSuperheats, bestPred.(hfp), '-', ...
        'Color', colors(h,:), 'LineWidth', 1.8, ...
        'DisplayName', sprintf('%s (best)', hfp));

    % Formatting
    xlabel(ax, '\DeltaT_{wall} (K)', 'FontSize', 10);
    if h == 1
        ylabel(ax, 'q_{total} (W/m^2)', 'FontSize', 10);
    end
    title(ax, hfp, 'FontSize', 11, 'FontWeight', 'bold');
    legend(ax, 'Location', 'northwest', 'FontSize', 8);
    grid(ax, 'on');
    box(ax, 'on');
    set(ax, 'FontSize', 9, 'YScale', 'linear');

    % Annotate with MAPE
    cfg  = bestCfg.(hfp);
    note = sprintf('MAPE = %.1f%%\nDd: %s\nf: %s\nN_b: %s\nt_w: %s\nt_g: %s\nNu: %s', ...
        bestMAPE.(hfp), ...
        char(cfg.departureDiameterModel), char(cfg.departureFrequencyModel), ...
        char(cfg.nucleationSiteModel), char(cfg.waitTimeModel), ...
        char(cfg.growthTimeModel), char(cfg.convectiveModel));
    text(ax, 0.97, 0.05, note, 'Units', 'normalized', ...
        'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom', ...
        'FontSize', 7, 'BackgroundColor', [1 1 1 0.8], ...
        'Interpreter', 'none');
end

sgtitle(sprintf('Best HFP Configurations — %s Dataset, %s', datasetName, caseLabel), ...
    'FontSize', 12, 'FontWeight', 'bold');

% Save figure
figFile = fullfile(resultsDir, sprintf('boilingCurves_%s.png', caseLabel));
exportgraphics(fig, figFile, 'Resolution', 300);
fprintf('\nFigure saved to: %s\n', figFile);

% =========================================================================
% LOCAL FUNCTIONS
% =========================================================================
