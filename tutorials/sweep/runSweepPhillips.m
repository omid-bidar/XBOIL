% runSweepPhillips
%
% Example sweep over all model combinations for Phillips et al. (case 1).
% Runs the full combinatorial evaluation of heat flux partitioning (HFP)
% and bubble dynamics sub-models, then ranks results by MSE against the
% experimental boiling curve.
%
% The script is designed to be run from the XBOIL root directory after
% calling startupXBOIL to load module paths.
%
% Requirements:
%   - MATLAB Parallel Computing Toolbox (optional; set nCores = 1 to run serially)
%   - CoolProp MATLAB wrapper on the MATLAB path
%   - data/Phillips.mat present in the XBOIL root (see data/README.md)
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
% 0) STARTUP
% -------------------------------------------------------------------------
if ~exist('calcTotalHeatFlux', 'file')
    if exist('startupXBOIL.m', 'file')
        run('startupXBOIL.m');
    else
        error('startupXBOIL.m not found. Run this script from the XBOIL root directory.');
    end
end

% -------------------------------------------------------------------------
% 1) USER OPTIONS
% -------------------------------------------------------------------------
nCores       = 12;    % Number of parallel workers (set to 1 for serial)
datasetName  = 'Phillips';
caseLabel    = 'case1';
resultsDir   = fullfile('results', [datasetName '_' caseLabel], filesep);

% -------------------------------------------------------------------------
% 2) LOAD DATA
% -------------------------------------------------------------------------
dataFile = fullfile('data', [datasetName '.mat']);
if ~exist(dataFile, 'file')
    error(['Data file not found: %s\n' ...
           'Please place %s.mat in the data/ directory.\n' ...
           'Run this script from the XBOIL root directory.'], dataFile, datasetName);
end
S = load(dataFile);
caseDict = S.(datasetName).(caseLabel);

wallSuperheats = caseDict.totalHeatFluxExperiment(:, 1);
wallSuperheats = wallSuperheats(wallSuperheats >= 0);

% -------------------------------------------------------------------------
% 3) SETUP OUTPUT DIRECTORY AND LOGGING
% -------------------------------------------------------------------------
if ~exist(resultsDir, 'dir')
    mkdir(resultsDir);
end

configFile = fullfile(resultsDir, 'modelConfig.mat');
resultFile = fullfile(resultsDir, 'allModelResults.mat');

% Detect stale results (e.g. after model renames) and let the user decide
% whether to overwrite in place or redirect to a new folder.
[resultsDir, configFile, resultFile] = resolveResultsDirectory( ...
    resultsDir, configFile, resultFile, caseLabel, datasetName);

if ~exist(resultsDir, 'dir')
    mkdir(resultsDir);
end

logFile = setupLogging(resultsDir);

logMessage(logFile, '=====================================================\n');
logMessage(logFile, '           XBOIL Sweep Log File                     \n');
logMessage(logFile, '=====================================================\n');
logMessage(logFile, 'Date & Time : %s\n', datestr(now, 'dd-mm-yyyy HH:MM:SS'));
logMessage(logFile, 'Dataset     : %s, %s\n', datasetName, caseLabel);
logMessage(logFile, '\n');

% -------------------------------------------------------------------------
% 4) INITIALISE MODEL CONFIGURATION
% -------------------------------------------------------------------------
logMessage(logFile, '>>> INITIALISATION <<<\n');
config = initialiseConfiguration(configFile, logFile);

nCores = max(nCores, 1);
logMessage(logFile, 'Number of cores : %d\n', nCores);
logMessage(logFile, '\n');

logMessage(logFile, '>>> FLOW AND HEATER CONDITIONS <<<\n');
logFlowAndHeaterProperties(caseDict, logFile);

logMessage(logFile, '>>> WALL SUPERHEATS <<<\n');
logMessage(logFile, '  Number of points : %d\n',     numel(wallSuperheats));
logMessage(logFile, '  Min              : %.2f K\n', min(wallSuperheats));
logMessage(logFile, '  Max              : %.2f K\n', max(wallSuperheats));
logMessage(logFile, '\n');

% -------------------------------------------------------------------------
% 5) BUILD COMBINATION LIST
% -------------------------------------------------------------------------
[HFPModels, convModels, nucSiteModels, ...
 depFreqModels, depDiamModels, ...
 waitTimeModels, growthTimeModels] = ndgrid( ...
    config.HFPModels, ...
    config.convectiveModels, ...
    config.nucleationSiteModels, ...
    config.departureFrequencyModels, ...
    config.departureDiameterModels, ...
    config.waitTimeModels, ...
    config.growthTimeModels);

combinations = [HFPModels(:), convModels(:), nucSiteModels(:), ...
                depFreqModels(:), depDiamModels(:), ...
                waitTimeModels(:), growthTimeModels(:)];

totalIterations = size(combinations, 1);
logMessage(logFile, '>>> COMBINATIONS <<<\n');
logMessage(logFile, '  Total configurations : %d\n\n', totalIterations);

% -------------------------------------------------------------------------
% 6) LOAD EXISTING RESULTS (ALLOWS RESUME)
% -------------------------------------------------------------------------
existingData = loadResultsFromMAT(resultFile);

% -------------------------------------------------------------------------
% 7) PARALLEL SWEEP
% -------------------------------------------------------------------------
if nCores > 1 && isempty(gcp('nocreate'))
    parpool('local', nCores);
end

resultsCollector  = parallel.pool.DataQueue;
toRemove          = false(totalIterations, 1);
skippedCount      = 0;

myListener = afterEach(resultsCollector, ...
    @(~) incrementProgress(totalIterations, 5, logFile));

logMessage(logFile, '>>> SIMULATION STARTED <<<\n\n');
logMessage(logFile, '  Progress  | Elapsed (min) | ~Remaining (min)\n');
logMessage(logFile, '  ------------------------------------------\n');
logMessage(logFile, '  %7.0f%%  | %13.2f | %16s\n', 0.0, 0.0, 'N/A');
startTime = tic;

parfor iter = 1:totalIterations
    try
        currentConfig = struct( ...
            'HFPModel',                string(combinations{iter, 1}), ...
            'convectiveModel',         string(combinations{iter, 2}), ...
            'nucleationSiteModel',     string(combinations{iter, 3}), ...
            'departureFrequencyModel', string(combinations{iter, 4}), ...
            'departureDiameterModel',  string(combinations{iter, 5}), ...
            'waitTimeModel',           string(combinations{iter, 6}), ...
            'growthTimeModel',         string(combinations{iter, 7}));
        currentConfig = orderfields(currentConfig);

        % Skip if already computed
        if ~isempty(findConfigurationIndex(existingData.configurations, currentConfig))
            skippedCount = skippedCount + 1;
            continue;
        end

        simulationResults = runSingleSimulation(caseDict, currentConfig, wallSuperheats);

        % Write partial results per worker
        task = getCurrentTask();
        workerID = 0;
        if ~isempty(task)
            workerID = task.ID;
        end
        savePartialResults(fullfile(resultsDir, sprintf('partial_%d.mat', workerID)), ...
                           currentConfig, simulationResults);

        send(resultsCollector, 1);
    catch ME
        toRemove(iter) = true;
        logMessage(logFile, 'Error in configuration %d: %s\n', iter, ME.message);
    end
end

delete(myListener);

% -------------------------------------------------------------------------
% 8) MERGE PARTIAL FILES AND CLEAN UP
% -------------------------------------------------------------------------
mergePartialResults(resultFile, resultsDir, logFile);

% -------------------------------------------------------------------------
% 9) RANK RESULTS
% -------------------------------------------------------------------------
logMessage(logFile, '\n>>> RANKING RESULTS <<<\n');

load(resultFile, 'existingData');
nResults = numel(existingData.results);

experimentalHeatFlux = caseDict.totalHeatFluxExperiment(:, 2);
experimentalHeatFlux = experimentalHeatFlux(caseDict.totalHeatFluxExperiment(:, 1) >= 0);

allPredictions = zeros(numel(wallSuperheats), nResults);
for i = 1:nResults
    allPredictions(:, i) = existingData.results{i}.totalHeatFlux;
end

errors = MSE(allPredictions, experimentalHeatFlux);
[sortedErrors, sortedIdx] = sort(errors, 'ascend');

rankHdr = sprintf('  %4s  %-14s  %-10s  %-23s  %-16s  %-18s  %-12s  %-12s  %-15s', ...
    'Rank', 'MSE (W/m^2)^2', 'HFP', 'Dd', 'freq', 'Nb', 'tw', 'tg', 'Nu');
logMessage(logFile, '%s\n%s\n', rankHdr, repmat('-', 1, numel(rankHdr)));
for r = 1:min(10, nResults)
    cfg = existingData.configurations{sortedIdx(r)};
    logMessage(logFile, '  %4d  %-14.4e  %-10s  %-23s  %-16s  %-18s  %-12s  %-12s  %-15s\n', ...
        r, sortedErrors(r), ...
        char(cfg.HFPModel), char(cfg.departureDiameterModel), ...
        char(cfg.departureFrequencyModel), char(cfg.nucleationSiteModel), ...
        char(cfg.waitTimeModel), char(cfg.growthTimeModel), char(cfg.convectiveModel));
end

% -------------------------------------------------------------------------
% 10) SUMMARY
% -------------------------------------------------------------------------
totalTimeMinutes = toc(startTime) / 60;
logMessage(logFile, '\n>>> SUMMARY <<<\n');
logMessage(logFile, '  Total configurations evaluated : %d\n', nResults);
logMessage(logFile, '  Skipped (already computed)     : %d\n', skippedCount);
logMessage(logFile, '  Total time                     : %.2f min\n', totalTimeMinutes);
logMessage(logFile, '\nResults saved to: %s\n', resultFile);

fprintf('\nDone. Results saved to %s\n', resultFile);

% ==========================================================================
%  LOCAL FUNCTIONS
% ==========================================================================

% --------------------------------------------------------------------------
function [resultsDir, configFile, resultFile] = resolveResultsDirectory( ...
        resultsDir, configFile, resultFile, caseLabel, datasetName)
% Checks whether saved results or the saved config contain model names that
% are no longer valid (e.g. after a rename).  If stale data is detected the
% user is offered two options:
%   1 – Delete the old files and re-run in the same folder.
%   2 – Choose a new folder label and redirect all output there.

    % Current paper model names (must stay in sync with initialiseConfiguration).
    validNames = [ ...
        "KimAndKim", "MIT", "RPI", ...
        "ChurchillAndChu", "Gnielinski", ...
        "HibikiIshii", "HibikiIshiiMIT", "LemmertChawla", "Li", "WangDhir", "Yang", ...
        "Cole", "Exact", "PeeblesAndGarber", "SakashitaAndOno", "Stephan", "Zuber", ...
        "Bovard", "ColeAndRohsenow", "ColomboAndFairweather", "Fritz", "GolorinAndKolchugin", ...
        "Kocamastafaogullari", "Nam", "Phan", "Ruckenstein", ...
        "TolubinskyAndKostanchuk", "VanStralenAndZijl", ...
        "MIT", "VanStralen", "Lee"];

    stale = false;

    % Check saved config file
    if exist(configFile, 'file')
        loaded = load(configFile, 'config');
        if isfield(loaded, 'config')
            cfg = loaded.config;
            allSaved = [];
            flds = fieldnames(cfg);
            for i = 1:numel(flds)
                allSaved = [allSaved, cfg.(flds{i})]; %#ok<AGROW>
            end
            if any(~ismember(allSaved, validNames))
                stale = true;
            end
        end
    end

    % Also check a sample of saved results if the config looks fine
    if ~stale && exist(resultFile, 'file')
        loaded = load(resultFile, 'existingData');
        if isfield(loaded, 'existingData') && ~isempty(loaded.existingData.configurations)
            cfg = loaded.existingData.configurations{1};
            modelValues = struct2cell(cfg);
            if any(~ismember([modelValues{:}], validNames))
                stale = true;
            end
        end
    end

    if ~stale
        return;
    end

    fprintf('\n');
    fprintf('  [WARNING] Existing results in ''%s'' contain model names\n', resultsDir);
    fprintf('  that differ from the current configuration (e.g. after a rename).\n');
    fprintf('  Running as-is would mix old and new results.\n\n');
    fprintf('  Options:\n');
    fprintf('    1 - Delete the old results and re-run in the same folder\n');
    fprintf('        (%s)\n', resultsDir);
    fprintf('    2 - Keep the old results and save new ones to a different folder\n\n');

    choice = input('  Enter choice (1 or 2): ');

    if choice == 1
        if exist(resultFile, 'file'),  delete(resultFile);  end
        if exist(configFile, 'file'),  delete(configFile);  end
        fprintf('\n  Old results deleted. Starting fresh in %s\n\n', resultsDir);

    elseif choice == 2
        newLabel = input(sprintf('  Enter folder label (default: %s_v2): ', ...
            [datasetName '_' caseLabel]), 's');
        if isempty(newLabel)
            newLabel = [caseLabel '_v2'];
        end
        resultsDir = fullfile('results', newLabel, filesep);
        configFile = fullfile(resultsDir, 'modelConfig.mat');
        resultFile = fullfile(resultsDir, 'allModelResults.mat');
        fprintf('\n  Output redirected to: %s\n\n', resultsDir);

    else
        error('Invalid choice. Exiting.');
    end
end

% --------------------------------------------------------------------------
function config = initialiseConfiguration(configFile, logFile)
% Loads an existing configuration or creates the default one.

    % Model lists correspond exactly to those evaluated in the associated
    % publication (Bidar & Colombo, Int. J. Heat Mass Transfer, 2026).
    % See Table 1 and Appendix A for full model descriptions and references.

    defaultConfig.HFPModels = string([ ...
        "KimAndKim", "MIT", "RPI"]);                             % 3 models, Table A.1

    defaultConfig.convectiveModels = string([ ...
        "ChurchillAndChu", "Gnielinski"]);                       % 2 models, Table A.6

    defaultConfig.nucleationSiteModels = string([ ...
        "HibikiIshii", "HibikiIshiiMIT", ...
        "LemmertChawla", "Li", "WangDhir", "Yang"]);             % 6 models, Table A.4

    defaultConfig.departureFrequencyModels = string([ ...
        "Cole", "Exact", "PeeblesAndGarber", ...
        "SakashitaAndOno", "Stephan", "Zuber"]);                 % 6 models, Table A.3
    % "Exact" = f = 1/(tg+tw) by definition (Table A.3)

    defaultConfig.departureDiameterModels = string([ ...
        "Bovard", "Cole", "ColeAndRohsenow", "ColomboAndFairweather", "Fritz", ...
        "GolorinAndKolchugin", "Kocamastafaogullari", ...
        "MIT", "Nam", "Phan", ...
        "Ruckenstein", "TolubinskyAndKostanchuk", "VanStralenAndZijl"]); % 13 models, Table A.2

    defaultConfig.waitTimeModels = string([ ...
        "MIT", "VanStralen"]);                                   % 2 models, Table A.5

    defaultConfig.growthTimeModels = string([ ...
        "MIT", "Lee", "VanStralen"]);                            % 3 models, Table A.5

    if exist(configFile, 'file')
        load(configFile, 'config');
        logMessage(logFile, 'Configuration loaded from %s.\n', configFile);
    else
        config = struct();
        logMessage(logFile, 'No configuration file found. Using default configuration.\n');
    end

    config = updateMissingModels(config, defaultConfig);
    save(configFile, 'config');

    logMessage(logFile, '\n>>> MODEL LISTS <<<\n');
    fields = fieldnames(config);
    for i = 1:numel(fields)
        logMessage(logFile, '  %-30s: %s\n', fields{i}, strjoin(config.(fields{i}), ', '));
    end
    logMessage(logFile, '\n');
end

% --------------------------------------------------------------------------
function config = updateMissingModels(config, defaultConfig)
    fields = fieldnames(defaultConfig);
    for i = 1:numel(fields)
        f = fields{i};
        if isfield(config, f)
            config.(f) = union(config.(f), defaultConfig.(f), 'stable');
        else
            config.(f) = defaultConfig.(f);
        end
    end
end

% --------------------------------------------------------------------------
function existingData = loadResultsFromMAT(resultFile)
    if exist(resultFile, 'file')
        load(resultFile, 'existingData');
    else
        existingData = struct('configurations', {{}}, 'results', {{}});
    end
    if ~isfield(existingData, 'configurations') || ~iscell(existingData.configurations)
        existingData.configurations = {};
    end
    if ~isfield(existingData, 'results') || ~iscell(existingData.results)
        existingData.results = {};
    end
end

% --------------------------------------------------------------------------
function simulationResults = runSingleSimulation(caseDict, config, wallSuperheats)
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

    nSuperheats           = numel(wallSuperheats);
    totalHeatFlux         = zeros(nSuperheats, 1);
    departureDiameter     = zeros(nSuperheats, 1);
    departureFrequency    = zeros(nSuperheats, 1);
    nucleationSiteDensity = zeros(nSuperheats, 1);
    waitTime              = zeros(nSuperheats, 1);
    growthTime            = zeros(nSuperheats, 1);

    for p = 1:nSuperheats
        dT = wallSuperheats(p);
        totalHeatFlux(p)         = calcTotalHeatFlux(dT);
        departureDiameter(p)     = calcDepartureDiameter(dT);
        departureFrequency(p)    = calcDepartureFrequency(dT);
        nucleationSiteDensity(p) = calcNucleationSiteDensity(dT);
        waitTime(p)              = calcWaitTime(dT);
        growthTime(p)            = calcGrowthTime(dT);
    end

    simulationResults = struct( ...
        'totalHeatFlux',         totalHeatFlux, ...
        'departureDiameter',     departureDiameter, ...
        'departureFrequency',    departureFrequency, ...
        'nucleationSiteDensity', nucleationSiteDensity, ...
        'waitTime',              waitTime, ...
        'growthTime',            growthTime);
end

% --------------------------------------------------------------------------
function index = findConfigurationIndex(configurations, config)
    config = orderfields(config);
    index  = [];
    for i = 1:numel(configurations)
        if isequal(orderfields(configurations{i}), config)
            index = i;
            return;
        end
    end
end

% --------------------------------------------------------------------------
function savePartialResults(partialFile, configToSave, resultToSave)
    if exist(partialFile, 'file')
        loaded = load(partialFile, 'partialData');
        if isfield(loaded, 'partialData') && isscalar(loaded.partialData)
            partialData = loaded.partialData;
        else
            partialData = initPartialData();
        end
    else
        partialData = initPartialData();
    end
    partialData.configurations{end+1} = configToSave;
    partialData.results{end+1}        = resultToSave;
    save(partialFile, 'partialData');
end

% --------------------------------------------------------------------------
function s = initPartialData()
    s = struct('configurations', {{}}, 'results', {{}});
end

% --------------------------------------------------------------------------
function mergePartialResults(resultFile, resultsDir, logFile)
    partialFiles = dir(fullfile(resultsDir, 'partial_*.mat'));
    if isempty(partialFiles)
        logMessage(logFile, 'No partial files found for merging.\n');
        return;
    end

    if exist(resultFile, 'file')
        load(resultFile, 'existingData');
    else
        existingData = struct('configurations', {{}}, 'results', {{}});
    end

    for i = 1:numel(partialFiles)
        loaded = load(fullfile(resultsDir, partialFiles(i).name), 'partialData');
        if ~isfield(loaded, 'partialData') || ~isscalar(loaded.partialData)
            logMessage(logFile, 'Warning: skipping malformed partial file %s\n', partialFiles(i).name);
            continue;
        end
        pd = loaded.partialData;
        if ~iscell(pd.configurations), pd.configurations = {pd.configurations}; end
        if ~iscell(pd.results),        pd.results        = {pd.results};        end
        existingData.configurations = [existingData.configurations, pd.configurations{:}];
        existingData.results        = [existingData.results,        pd.results{:}];
    end

    save(resultFile, 'existingData', '-v7.3');

    for i = 1:numel(partialFiles)
        delete(fullfile(resultsDir, partialFiles(i).name));
    end
end

% --------------------------------------------------------------------------
function logFile = setupLogging(resultsDir)
    timestamp = datestr(now, 'dd-mm-yyyy_HH-MM-SS');
    logFile   = fullfile(resultsDir, sprintf('%s.log', timestamp));
    fid = fopen(logFile, 'w');
    if fid ~= -1
        fclose(fid);
    else
        error('Could not create log file: %s', logFile);
    end
end

% --------------------------------------------------------------------------
function logMessage(logFile, format, varargin)
    fprintf(format, varargin{:});
    fid = fopen(logFile, 'a');
    if fid ~= -1
        fprintf(fid, format, varargin{:});
        fclose(fid);
    else
        warning('Could not write to log file: %s', logFile);
    end
end

% --------------------------------------------------------------------------
function logFlowAndHeaterProperties(caseDict, logFile)
    fields = {'fluid', 'pressure', 'velocity', 'massFlux', 'subcooling', ...
              'hydraulicDiameter', 'referenceLength', 'contactAngle'};
    units  = {'', 'bar', 'm/s', 'kg/m^2/s', 'K', 'm', 'm', 'deg'};
    fmt    = {'%s', '%.2e', '%.2e', '%.2e', '%.2e', '%.4e', '%.4e', '%.2f'};

    logMessage(logFile, '  Flow conditions:\n');
    for i = 1:numel(fields)
        if isfield(caseDict, fields{i})
            val = caseDict.(fields{i});
            if ischar(val) || isstring(val)
                logMessage(logFile, ['    %-22s: ' fmt{i} '\n'], fields{i}, val);
            else
                logMessage(logFile, ['    %-22s: ' fmt{i} ' %s\n'], fields{i}, val, units{i});
            end
        end
    end

    heaterFields = {'heaterMaterial', 'heaterDensity', 'heaterSpecificHeatCapacity', ...
                    'heaterThermalDiffusivity', 'heaterThermalConductivity'};
    heaterUnits  = {'', 'kg/m^3', 'J/kg.K', 'm^2/s', 'W/m.K'};
    heaterFmt    = {'%s', '%.2f', '%.2e', '%.6e', '%.2e'};

    logMessage(logFile, '  Heater properties:\n');
    for i = 1:numel(heaterFields)
        if isfield(caseDict, heaterFields{i})
            val = caseDict.(heaterFields{i});
            if ischar(val) || isstring(val)
                logMessage(logFile, ['    %-30s: ' heaterFmt{i} '\n'], heaterFields{i}, val);
            else
                logMessage(logFile, ['    %-30s: ' heaterFmt{i} ' %s\n'], heaterFields{i}, val, heaterUnits{i});
            end
        end
    end
    logMessage(logFile, '\n');
end

% --------------------------------------------------------------------------
function incrementProgress(totalIterations, progressThreshold, logFile)
    persistent progressCount lastPrintedPercent startTime headerPrinted;
    if isempty(progressCount)
        progressCount      = 0;
        lastPrintedPercent = 0;
        startTime          = tic;
        headerPrinted      = false;
    end
    headerPrinted = true; % header printed before parfor
    progressCount   = progressCount + 1;
    progressPercent = (progressCount / totalIterations) * 100;
    if (progressPercent - lastPrintedPercent) >= progressThreshold
        lastPrintedPercent = progressPercent;
        elapsed   = toc(startTime) / 60;
        remaining = (elapsed / progressCount) * totalIterations - elapsed;
        logMessage(logFile, '  %7.0f%%  | %13.2f | %16.2f\n', ...
                   progressPercent, elapsed, remaining);
    end
end
