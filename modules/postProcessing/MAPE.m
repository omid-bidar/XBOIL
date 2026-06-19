function errors = MAPE(predictions, targets)
    % MAPE Calculates Mean Absolute Percentage Error
    errors = mean(abs((targets - predictions) ./ targets) * 100, 1);
end