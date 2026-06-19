function r2 = R2(predictions, targets)
    % R2 Calculates R-squared (Coefficient of Determination)
    ss_res = sum((targets - predictions).^2, 1); % Residual sum of squares
    ss_tot = sum((targets - mean(targets, 1)).^2, 1); % Total sum of squares
    r2 = 1 - (ss_res ./ ss_tot);
end