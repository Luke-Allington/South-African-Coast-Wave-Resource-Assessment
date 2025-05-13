% South African Wave Resource Assessment

clear; clc; close all;

%% === 1. File Setup ===
% Define the CSV filename (should be in the same folder as this script)
filePath = 'SundayEastlondon.csv';

% Quick check to make sure the file actually exists
if ~isfile(filePath)
    error('File not found: %s. Make sure it''s in the same folder.', filePath);
end

%% === 2. Load and Prepare Data ===
% Load and clean the wave data from the CSV file
data = loadWaveData(filePath);

%% === 3. Print Basic Stats to Console ===
% Gives a quick overview of what the dataset looks like
% (number of entries, average wave height, etc.)
displaySummaryStats(data);

%% === 4. Generate Plots ===
% Time series, histogram, polar plot, 3D trends, and monthly averages
plotWaveTimeSeries(data);
plotWaveHistogram(data);
plotWaveDirectionPolar(data);
plot3DWaveTrend(data);
plotMonthlyMeanHMO(data);

%% === 5. Export Summary ===
% Save a quick summary report to CSV for sharing or archiving
exportSummaryToCSV(data, 'Wave_Analysis_Report.csv');

fprintf('\n Done! Summary saved to "Wave_Analysis_Report.csv"\n');

%% === Helper Functions ===

function data = loadWaveData(filePath)
    % Import the wave data CSV using defined column names and types
    opts = detectImportOptions(filePath, 'Delimiter', ',');
    opts.VariableNames = {'Date', 'Time', 'HMO', 'TP', 'DIR'};
    opts.VariableTypes = {'string', 'string', 'double', 'double', 'double'};
    opts.DataLines = [2 Inf];

    % Read the file into a table
    data = readtable(filePath, opts);

    % Combine date and time into a single datetime column
    data.DateTime = datetime(strcat(strtrim(data.Date), {' '}, strtrim(data.Time)), ...
                             'InputFormat', 'dd/MM/yyyy HH:mm');

    % Remove any rows that have missing values or broken timestamps
    data = data(~isnat(data.DateTime) & ~any(ismissing(data(:, {'HMO', 'TP', 'DIR'})), 2), :);

    % Sort data by time to keep things tidy
    data = sortrows(data, 'DateTime');

    % Add Year and Month columns for grouping later
    data.Month = month(data.DateTime);
    data.Year = year(data.DateTime);
end

function displaySummaryStats(data)
    fprintf('\n Quick Look at the Dataset:\n');
    fprintf('------------------------------\n');
    fprintf('Total rows: %d\n', height(data));
    fprintf('Time span: %s to %s\n', datestr(min(data.DateTime)), datestr(max(data.DateTime)));
    fprintf('Avg Wave Height (HMO): %.2f m\n', mean(data.HMO));
    fprintf('Max Wave Height: %.2f m\n', max(data.HMO));
    fprintf('Avg Peak Period (TP): %.2f s\n', mean(data.TP));
    fprintf('Avg Wave Direction: %.2f°\n', mean(data.DIR));
end

function plotWaveTimeSeries(data)
    figure('Name', 'Wave Time Series', 'Color', 'w');
    tiledlayout(3,1, 'Padding', 'compact', 'TileSpacing', 'compact');

    % Plot HMO over time
    nexttile;
    plot(data.DateTime, data.HMO, 'b-', 'LineWidth', 1.5);
    ylabel('HMO (m)'); grid on; title('Significant Wave Height');

    % Plot TP over time
    nexttile;
    plot(data.DateTime, data.TP, 'r-', 'LineWidth', 1.5);
    ylabel('TP (s)'); grid on; title('Peak Wave Period');

    % Plot direction over time
    nexttile;
    plot(data.DateTime, data.DIR, 'g-', 'LineWidth', 1.5);
    ylabel('Direction (°)'); xlabel('Date'); grid on; title('Wave Direction');

    sgtitle('Time Series of Wave Parameters');
end

function plotWaveHistogram(data)
    % Show how wave height is distributed across the dataset
    figure('Name', 'Wave Height Histogram', 'Color', 'w');
    histogram(data.HMO, 20, 'FaceColor', '#0072BD', 'EdgeColor', 'k');
    xlabel('Significant Wave Height (m)'); ylabel('Frequency');
    title('Histogram of Wave Heights'); grid on;
end

function plotWaveDirectionPolar(data)
    % Plot direction vs wave height in polar coordinates
    figure('Name', 'Wave Direction Polar Plot', 'Color', 'w');
    polarplot(deg2rad(data.DIR), data.HMO, 'o', 'MarkerFaceColor', '#0072BD', ...
        'MarkerEdgeColor', 'k', 'MarkerSize', 4);
    title('Wave Direction vs Height');
end

function plot3DWaveTrend(data)
    % Explore the relationship between wave period, height, and time
    figure('Name', '3D Plot: HMO vs TP vs Time', 'Color', 'w');
    plot3(datenum(data.DateTime), data.TP, data.HMO, '.', 'MarkerSize', 8);
    xlabel('Time'); ylabel('Peak Period (s)'); zlabel('Wave Height (m)'); grid on;
    title('Wave Height vs Period vs Time');
    datetick('x', 'yyyy', 'keeplimits');
    view([-45 20]);
end

function plotMonthlyMeanHMO(data)
    % Calculate and plot average HMO by month/year
    monthlyStats = groupsummary(data, {'Year', 'Month'}, 'mean', 'HMO');
    monthlyStats.Date = datetime(monthlyStats.Year, monthlyStats.Month, 1);

    figure('Name', 'Monthly Averages', 'Color', 'w');
    plot(monthlyStats.Date, monthlyStats.mean_HMO, '-o', 'LineWidth', 2, ...
         'MarkerFaceColor', '#D95319');
    xlabel('Date'); ylabel('Mean HMO (m)'); grid on;
    title('Monthly Mean Wave Height');
end

function exportSummaryToCSV(data, filename)
    % Save key stats to a CSV file for reporting or later use
    metrics = ["Start Date"; "End Date"; "Mean HMO"; "Max HMO"; "Mean TP"; "Mean DIR"];
    values = [string(min(data.DateTime)); string(max(data.DateTime));
              string(sprintf('%.2f', mean(data.HMO))); string(sprintf('%.2f', max(data.HMO)));
              string(sprintf('%.2f', mean(data.TP))); string(sprintf('%.2f', mean(data.DIR)))];

    reportTable = table(metrics, values, 'VariableNames', {'Metric', 'Value'});
    writetable(reportTable, filename);
end
