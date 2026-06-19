function errors = MAE(predictions, targets)
    % MAE Calculates Mean Absolute Error
    errors = mean(abs(predictions - targets), 1);
end