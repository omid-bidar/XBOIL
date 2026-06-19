function colors = generateDistinctColors(numColours, colorMap)
    if nargin < 1
        numColours = 100;
    end
    if nargin < 2
        colorMap = 'parula';
    end
    if numColours < 1
        error('Number of colors must be at least 1.');
    end

    % Convert string to char if needed
    if isstring(colorMap)
        colorMap = char(colorMap);
    end

    colorMapLower = lower(colorMap);

    try
        switch colorMapLower
            case 'parula'
                colors = parula(numColours);
            case 'jet'
                colors = jet(numColours);
            case 'hsv'
                colors = hsv(numColours);
            case 'hot'
                colors = hot(numColours);
            case 'cool'
                colors = cool(numColours);
            case 'spring'
                colors = spring(numColours);
            case 'summer'
                colors = summer(numColours);
            case 'autumn'
                colors = autumn(numColours);
            case 'winter'
                colors = winter(numColours);
            case 'lines'
                colors = lines(numColours);
            case 'gray'
                colors = gray(numColours);
            case 'turbo'
                colors = turbo(numColours);
            case 'bone'
                colors = bone(numColours);
            case 'colorcube'
                colors = colorcube(numColours);
            otherwise
                % Check if slanCM is available (200 colormap add-on)
                if exist('slanCM', 'file') == 2
                    cmap = slanCM(colorMap);  % returns [256 x 3] (or similar)
                    % Subsample or interpolate to desired number
                    idx = round(linspace(1, size(cmap, 1), numColours));
                    colors = cmap(idx, :);
                else
                    warning('slanCM not found. Cannot load 200 colormaps. Falling back to hsv.');
                    colors = hsv(numColours);
                end
        end
    catch ME
        warning('Error using colormap "%s": %s. Falling back to hsv.', colorMap, ME.message);
        colors = hsv(numColours);
    end
end