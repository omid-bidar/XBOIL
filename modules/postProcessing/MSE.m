function errors = MSE(predictions, targets)
    % MSE Calculates Mean Squared Error
    errors = mean((predictions - targets).^2, 1);
end