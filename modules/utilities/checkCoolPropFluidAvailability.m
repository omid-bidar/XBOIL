function checkCoolPropFluidAvailability(fluidName)

    coolprop = py.importlib.import_module('CoolProp.CoolProp');

    fluids = coolprop.get_global_param_string('fluids_list');

    fluidList = strsplit(char(fluids), ',');

    isAvailable = any(strcmp(fluidList, fluidName));

    if isAvailable

        fprintf('%s is available in CoolProp.\n', fluidName);

    else

        fprintf('%s is NOT available in CoolProp.\n', fluidName);

    end

end
