function errors = SMAPE(predictions, targets)
    % SMAPE Calculates Symmetric Mean Absolute Percentage Error
    errors = mean(2 * abs(predictions - targets) ./ (abs(targets) + abs(predictions)) * 100, 1);
end