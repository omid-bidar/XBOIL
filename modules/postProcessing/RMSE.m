function errors = RMSE(predictions, targets)
    % RMSE Calculates Root Mean Square Error
    errors = sqrt(mean((predictions - targets).^2, 1));
end