function modelCombination = getModelCombination(index, modelDictionary)
    % Extract model arrays from the dictionary
    HFPModels = modelDictionary.HFPModels;
    convectiveModels = modelDictionary.convectiveModels;
    nucleationSiteModels = modelDictionary.nucleationSiteModels;
    departureFrequencyModels = modelDictionary.departureFrequencyModels;
    departureDiameterModels = modelDictionary.departureDiameterModels;
    waitTimeModels = modelDictionary.waitTimeModels;
    growthTimeModels = modelDictionary.growthTimeModels;

    % Calculate the sizes of each dimension
    sizes = [length(HFPModels), length(convectiveModels), length(nucleationSiteModels), ...
             length(departureFrequencyModels), length(departureDiameterModels), ...
             length(waitTimeModels), length(growthTimeModels)];
    totalCombinations = prod(sizes);

    % Check if the index is within bounds
    if index > totalCombinations
        error('Index exceeds the total number of model combinations.');
    end

    % Initialize indices for each dimension
    indices = zeros(1, length(sizes));
    remainingIndex = index - 1; % Zero-based indexing for easier calculations

    % Calculate indices for each dimension
    for i = 1:length(sizes)
        indices(i) = mod(remainingIndex, sizes(i)) + 1;
        remainingIndex = floor(remainingIndex / sizes(i));
    end

    % Retrieve the corresponding models
    modelCombination.HFPModel = HFPModels(indices(1));
    modelCombination.convectiveModel = convectiveModels(indices(2));
    modelCombination.nucleationSiteModel = nucleationSiteModels(indices(3));
    modelCombination.departureFrequencyModel = departureFrequencyModels(indices(4));
    modelCombination.departureDiameterModel = departureDiameterModels(indices(5));
    modelCombination.waitTimeModel = waitTimeModels(indices(6));
    modelCombination.growthTimeModel = growthTimeModels(indices(7));
end