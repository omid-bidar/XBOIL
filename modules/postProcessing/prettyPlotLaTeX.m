% Use LaTeX
ax = gca;
set([ax.XLabel, ax.YLabel, ax.Title], 'Interpreter', 'latex');
ax.TickLabelInterpreter = 'latex';

% Main axes styling
ax.TickDir = 'out';
ax.LineWidth = 1.5;
ax.Layer = 'top';  % Put ticks above grid

% Keep ticks only on bottom and left
ax.Box = 'off'; % this disables top/right ticks
ax.XAxisLocation = 'bottom';
ax.YAxisLocation = 'left';

% Minor ticks halfway between major ones
ax.XMinorTick = 'on';
ax.YMinorTick = 'on';

% ---- X axis: only customise for linear scale ----
if strcmpi(ax.XScale, 'linear') && numel(ax.XTick) > 1
    ax.XAxis.MinorTickValues = ...
        ax.XTick(1:end-1) + diff(ax.XTick)/2;
end

% ---- Y axis: only customise for linear scale ----
if strcmpi(ax.YScale, 'linear') && numel(ax.YTick) > 1
    ax.YAxis.MinorTickValues = ...
        ax.YTick(1:end-1) + diff(ax.YTick)/2;
end

% Set tick lengths
ax.TickLength = [0.03, 0.01];

% Draw custom box manually
hold on
xl = xlim(ax); yl = ylim(ax);
plot([xl(1), xl(2)], [yl(1), yl(1)], 'k', 'LineWidth', 2, 'HandleVisibility', 'off'); % bottom
plot([xl(1), xl(1)], [yl(1), yl(2)], 'k', 'LineWidth', 2, 'HandleVisibility', 'off'); % left
plot([xl(1), xl(2)], [yl(2), yl(2)], 'k', 'LineWidth', 2, 'HandleVisibility', 'off'); % top
plot([xl(2), xl(2)], [yl(1), yl(2)], 'k', 'LineWidth', 2, 'HandleVisibility', 'off'); % right
uistack(ax.Children(1), 'bottom'); % ensure data line is on top
hold off
axis square; 

% % Apply settings to current axis
% set(gca, 'FontSize', 12, 'TickLabelInterpreter', 'latex');
% set(gca, 'XMinorTick', 'on', 'YMinorTick', 'on');  % Turn off minor ticks
% set(gca, 'XMinorTick', 'on', 'YMinorTick', 'on');  % Turn off minor ticks
% set(gca, 'TickDir', 'out', 'TickLength', [0.03, 0.0025]);
% % set(gca, 'TickLength', [0.05, 0.001]);
% set(gca, 'GridLineStyle', ':', 'GridColor', 'k');
% set(gca, 'LineWidth', 1.5, 'Box', 'off');
% axis square; 
% 
% % Apply settings to current figure
% fig = gcf;
% set(fig, 'DefaultTextInterpreter', 'latex');
% set(fig, 'DefaultAxesTickLabelInterpreter', 'latex');
% set(fig, 'DefaultLegendInterpreter', 'latex');
% set(fig, 'DefaultAxesLineWidth', 2);
% box off;
% Enable the grid for the current axis
% grid on;

