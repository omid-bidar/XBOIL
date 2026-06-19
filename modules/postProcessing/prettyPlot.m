function prettyPlot(ax, varargin)
% PRETTYPLOT  Publication-style axes formatting with optional LaTeX cleanup.
%
%   prettyPlot()                % apply to gca, no auto LaTeX changes
%   prettyPlot(ax)              % apply to given axes
%   prettyPlot(...,'AutoLatexLabels',true)
%                               % also try to convert simple D_d-style labels
%
% Notes:
%   - By default, this function does NOT modify label strings, it only sets
%     interpreters to 'latex'. So if you use underscores, write LaTeX
%     explicitly, e.g. xlabel('Experimental $D_d$ [mm]')
%   - If 'AutoLatexLabels' is true, a conservative parser will wrap tokens
%     like "D_d" into "$D_d$" while leaving normal text and [mm] intact.

    % ------------------------------------------------------------
    % Handle input
    % ------------------------------------------------------------
    if nargin == 0 || isempty(ax) || ~isa(ax,'matlab.graphics.axis.Axes')
        ax = gca;
        args = varargin;
    else
        args = varargin;
    end

    % Simple name-value parsing
    autoLatex = false;
    if ~isempty(args)
        for k = 1:2:numel(args)
            name = args{k};
            if k+1 > numel(args)
                error('Name-value arguments must come in pairs.');
            end
            val = args{k+1};
            switch lower(name)
                case 'autolatexlabels'
                    autoLatex = logical(val);
                otherwise
                    error('Unknown parameter: %s', name);
            end
        end
    end

    % ------------------------------------------------------------
    % Optional: conservative LaTeX cleanup for X/Y labels only
    % ------------------------------------------------------------
    if autoLatex
        ax.XLabel.String = autoLatexLabel(ax.XLabel.String);
        ax.YLabel.String = autoLatexLabel(ax.YLabel.String);
        % Title is left as-is; usually descriptive text
    end

    % ------------------------------------------------------------
    % Text interpreters
    % ------------------------------------------------------------
    set([ax.XLabel, ax.YLabel, ax.Title], 'Interpreter', 'latex');
    ax.TickLabelInterpreter = 'latex';

    % ------------------------------------------------------------
    % Axes styling
    % ------------------------------------------------------------
    ax.TickDir   = 'out';
    ax.LineWidth = 1.4;
    ax.Layer     = 'top';
    ax.Box       = 'off';
    ax.XAxisLocation = 'bottom';
    ax.YAxisLocation = 'left';
    ax.TickLength    = [0.03 0.015];

    % Minor ticks halfway between major
    ax.XMinorTick = 'on';
    ax.YMinorTick = 'on';

    if numel(ax.XTick) > 1
        dx = diff(ax.XTick);
        ax.XAxis.MinorTickValues = ax.XTick(1:end-1) + dx/2;
    end
    if numel(ax.YTick) > 1
        dy = diff(ax.YTick);
        ax.YAxis.MinorTickValues = ax.YTick(1:end-1) + dy/2;
    end

    % ------------------------------------------------------------
    % Grid styling
    % ------------------------------------------------------------
    ax.GridLineStyle = '-';
    ax.GridColor     = [0.8 0.8 0.8];
    ax.GridAlpha     = 0.5;
    grid(ax, 'on');

    % ------------------------------------------------------------
    % Manual box
    % ------------------------------------------------------------
    hold(ax, 'on');
    xl = xlim(ax);
    yl = ylim(ax);
    lw = 1.4;

    plot(ax, [xl(1) xl(2)], [yl(1) yl(1)], 'k', 'LineWidth', lw, 'HandleVisibility','off');
    plot(ax, [xl(1) xl(1)], [yl(1) yl(2)], 'k', 'LineWidth', lw, 'HandleVisibility','off');
    plot(ax, [xl(1) xl(2)], [yl(2) yl(2)], 'k', 'LineWidth', lw, 'HandleVisibility','off');
    plot(ax, [xl(2) xl(2)], [yl(1) yl(2)], 'k', 'LineWidth', lw, 'HandleVisibility','off');
    hold(ax, 'off');

    ax.SortMethod = 'childorder';  % keep data on top

    % ------------------------------------------------------------
    % Figure-wide defaults
    % ------------------------------------------------------------
    fig = ancestor(ax, 'figure');
    if ~isempty(fig)
        set(fig, 'DefaultTextInterpreter', 'latex');
        set(fig, 'DefaultAxesTickLabelInterpreter', 'latex');
        set(fig, 'DefaultLegendInterpreter', 'latex');
    end

    axis(ax, 'square');
end


% ========================================================================
% Helper: conservative LaTeX conversion for labels
% ========================================================================
function out = autoLatexLabel(str)
    % Best-effort conversion of labels like
    %   'Experimental D_d [mm]'
    % → 'Experimental $D_d$ [mm]'
    %
    % Very conservative: only acts on simple tokens. If the user already
    % wrote LaTeX ($...$), we leave it alone.

    if ~ischar(str) && ~isstring(str)
        out = str;
        return;
    end
    str = char(str);

    if contains(str, '$')
        out = str;  % user already knows what they're doing
        return;
    end

    tokens = strsplit(str, ' ');
    greek  = ["alpha","beta","gamma","delta","mu","sigma","theta","lambda","phi"];

    for i = 1:numel(tokens)
        tk = tokens{i};
        if tk == ""
            continue;
        end

        % Units [mm] etc -> leave alone
        if startsWith(tk, '[') && endsWith(tk, ']')
            continue;
        end

        % Pure Greek names -> $\alpha$
        if any(strcmpi(tk, greek))
            tokens{i} = ['\' lower(tk)];
            continue;
        end

        % Simple variable with one underscore: D_d, q'', etc
        if ~contains(tk, '$') && contains(tk, '_') ...
                && isempty(regexp(tk, '\s', 'once')) ...
                && ~contains(tk, '[') && ~contains(tk, ']')
            % Escape underscore(s)
            tkEsc = strrep(tk, '_', '\_');
            tokens{i} = ['$' tkEsc '$'];
            continue;
        end

        % Simple superscript: x^2
        if contains(tk, '^')
            tk2 = regexprep(tk, '\^(\w+)', '^{\1}');
            tokens{i} = ['$' tk2 '$'];
            continue;
        end
    end

    out = strjoin(tokens, ' ');
end