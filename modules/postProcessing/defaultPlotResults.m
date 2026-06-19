function defaultPlotResults(wallSuperheats, experimentalHeatFlux, selectedModels, meanHeatFlux, selectedIndices, sortedErrors, caseDict)
    % PLOTRESULTS Plots experimental data and model predictions.
    %
    % INPUTS:
    %   - wallSuperheats: Array of wall superheat values.
    %   - experimentalHeatFlux: Experimental heat flux data.
    %   - selectedModels: Matrix of selected model predictions.
    %   - meanHeatFlux: Mean heat flux of the selected models.
    %   - selectedIndices: Indices of the selected models.
    %   - sortedErrors: Errors corresponding to the selected models.
    %   - caseDict: Dictionary containing experimental data for comparison.
    
    nModels = size(selectedModels, 2); % Number of models
    
    % Plot total heat flux against wall superheats
    figure(1);
    hold on;
    prettyPlot;
    colours = generateDistinctColors(nModels);
    for i = 1:nModels
        plot(wallSuperheats, selectedModels(:, i), '--', 'LineWidth', 1, 'Color', colours(i,:), ...
                 'DisplayName', sprintf('Model %d (Error: %.2f)', selectedIndices(i), sortedErrors(i)));
    end
    % Plot best model on top of all the lines
    h1 = plot(wallSuperheats, selectedModels(:,1), 'b-s', 'MarkerFaceColor', 'b', ...
        'DisplayName', 'Best Model', 'MarkerSize', 8);
    h2 = plot(wallSuperheats, meanHeatFlux, 'r-s', 'MarkerFaceColor', 'r', ...
        'DisplayName', 'Model Means', 'MarkerSize', 8);
    % Plot experimental data
    h3 = plot(wallSuperheats, experimentalHeatFlux, 'ks', 'MarkerFaceColor', 'none', ...
         'DisplayName', 'Experimental Data', 'MarkerSize', 8);
    xlabel('Wall Superheats [K]');
    ylabel('Total Heat Flux [W/m$^2$]');
    legend([h1, h2, h3], 'location', 'northWest', 'fontSize', 15, 'box', 'off');
    prettyPlot;

    % Plot predicted heat flux vs experimental heat flux
    figure(2);
    hold on;
    prettyPlot;
    plot(experimentalHeatFlux, experimentalHeatFlux, '--', 'Color', [0.5 0.5 0.5], 'LineWidth', 1.5, ...
         'DisplayName', 'y = x');
    for i = 1:nModels
        plot(experimentalHeatFlux, selectedModels(:, i), 'o', 'Color', [0.75, 0.75, 0.75], 'LineWidth', 1.5);
    end
    h1 = plot(experimentalHeatFlux, selectedModels(:, 1), '^b', 'MarkerFaceColor', 'b', ...
              'DisplayName', sprintf('Best Model (Error: %.2f)', sortedErrors(1)));
    h2 = plot(experimentalHeatFlux, meanHeatFlux, 'sr', 'MarkerFaceColor', 'r', ...
              'DisplayName', 'Mean of Selected Models');
    xlabel('Experimental Heat Flux [W/m$^2$]');
    ylabel('Predicted Heat Flux [W/m$^2$]');
    axis equal;
    xlim([0, max(experimentalHeatFlux) * 1.1]);
    ylim([0, max(experimentalHeatFlux) * 1.1]);
    legend([h1, h2], 'Location', 'northwest', 'Box', 'off', 'FontSize', 15);
    prettyPlot;
end