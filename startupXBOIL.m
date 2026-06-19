function startupXBOIL()

restoredefaultpath
rehash toolboxcache

repoRoot = fileparts(mfilename("fullpath"));

addpath(genpath(fullfile(repoRoot, "modules")));

fprintf("XBOIL paths loaded from:\n%s\n", repoRoot);

end
