function varargout = rankModelCombinations(inputData, nModels, errorMeasure, selectionType, varargin)
    % RANKMODELCOMBINATIONS Analyzes heat flux models and selects top/worst models.
    %
    % INPUTS:
    %   - inputData: Struct containing all necessary inputs (same as original).
    %   - nModels: Number of models to select.
    %   - errorMeasure: Function handle for error measure (e.g., @RMSE, @MAE).
    %   - selectionType: 'best' or 'worst', specifies top or worst models.
    %   - varargin: Optional key-value pairs for customization:
    %       * 'Plot': true/false (default: false), whether to plot results.
    %       * 'PlotFunction': function handle for custom plotting.
    %
    % OUTPUTS:
    %   - T: Table with the selected model combinations and their indices.
    %   - topModels: Matrix of predictions from the selected models.
    %   - meanHeatFlux: Mean heat flux of the selected models.
    %   - topErrors: Errors corresponding to the selected models.

    % Parse optional parameters
    p = inputParser;
    addParameter(p, 'Plot', false, @islogical);
    addParameter(p, 'PlotFunction', [], @(x) isempty(x) || isa(x, 'function_handle'));
    parse(p, varargin{:});
    doPlot = p.Results.Plot;
    plotFunction = p.Results.PlotFunction;

    % Extract inputs
    experimentalHeatFlux = inputData.experimentalHeatFlux;
    wallSuperheats = inputData.wallSuperheats;
    allModelPredictions = inputData.allModelPredictions;
    modelDictionary = inputData.modelDictionary;

    % Error calculation
    errors = errorMeasure(allModelPredictions, experimentalHeatFlux);
    
    % Select models
    if strcmp(selectionType, 'best')
        [sortedErrors, sortedIndices] = sort(errors, 'ascend');
    elseif strcmp(selectionType, 'worst')
        [sortedErrors, sortedIndices] = sort(errors, 'descend');
    else
        error('Invalid selectionType. Use "best" or "worst".');
    end
    selectedIndices = sortedIndices(1:nModels);
    topModels = allModelPredictions(:, selectedIndices);
    topErrors = sortedErrors(1:nModels);

    % Generate combinations for selected models
    selectedCombinations = cell(nModels, 8);
    for i = 1:nModels
        modelCombination = getModelCombination(selectedIndices(i), modelDictionary);
        selectedCombinations{i, 1} = selectedIndices(i);
        selectedCombinations{i, 2} = modelCombination.HFPModel;
        selectedCombinations{i, 3} = modelCombination.convectiveModel;
        selectedCombinations{i, 4} = modelCombination.nucleationSiteModel;
        selectedCombinations{i, 5} = modelCombination.departureFrequencyModel;
        selectedCombinations{i, 6} = modelCombination.departureDiameterModel;
        selectedCombinations{i, 7} = modelCombination.waitTimeModel;
        selectedCombinations{i, 8} = modelCombination.growthTimeModel;
    end

    % Create table
    T = cell2table(selectedCombinations, ...
        'VariableNames', {'Index', 'HFPModel', 'ConvectiveModel', 'NucleationSiteModel', ...
                          'DepartureFrequencyModel', 'DepartureDiameterModel', ...
                          'WaitTimeModel', 'GrowthTimeModel'});

    % Calculate mean heat flux
    meanHeatFlux = mean(topModels, 2);

    % Handle outputs dynamically
    nargoutchk(0, 4);
    varargout = cell(1, nargout);
    if nargout >= 1, varargout{1} = T; end
    if nargout >= 2, varargout{2} = topModels; end
    if nargout >= 3, varargout{3} = meanHeatFlux; end
    if nargout >= 4, varargout{4} = topErrors; end

    % Plot results if requested
    if doPlot
        if isempty(plotFunction)
            % Use default plotting function
            defaultPlotResults(wallSuperheats, experimentalHeatFlux, topModels, meanHeatFlux, selectedIndices, topErrors);
        else
            % Use custom plotting function
            plotFunction(wallSuperheats, experimentalHeatFlux, topModels, meanHeatFlux, selectedIndices, topErrors);
        end
    end
end