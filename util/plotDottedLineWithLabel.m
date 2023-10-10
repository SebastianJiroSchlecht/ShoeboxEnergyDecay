function plotDottedLineWithLabel(x_position, text_y, latex_string)
    ylim_temp = ylim;

    % Plot a vertical dotted line at the specified x_position
    x = [x_position, x_position];
    y = [-1 1]*text_y;
    line(x, y, 'LineStyle', ':', 'Color', 'k');

    % Add a vertical LaTeX text label in the middle of the line
    text_x = x_position - 0.005; % Shift the text slightly to the right of the line
    %text_y = mean(y_range);
    text(text_x, text_y, latex_string, 'Interpreter', 'latex', 'HorizontalAlignment', 'left', 'Rotation', 90);

    ylim(ylim_temp);
end