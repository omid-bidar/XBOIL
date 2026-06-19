function globalParams = getGlobalParams(initStruct)

    persistent settings;
    
    if nargin > 0 % Initialize settings if an input is provided
        settings = initStruct;
    end

    if isempty(settings)

        error('Global parameters have not been initialised.');

    end

    globalParams = settings; % Return the settings
    
end
