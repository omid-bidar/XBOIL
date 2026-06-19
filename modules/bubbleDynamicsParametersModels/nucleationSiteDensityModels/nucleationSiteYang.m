function nucleationSite = nucleationSiteYang(wallSuperheatI)

    nucleationSite = 1e4 * (0.28 * wallSuperheatI^2.66);

end
% Yang, L. X., Guo, A., & Liu, D. (2014). Experimental Investigation of
% Subcooled Vertical Upward Flow Boiling in a Narrow Rectangular Channel.
% Experimental Heat Transfer, 29(2), 221?243.
% https://doi.org/10.1080/08916152.2014.973978