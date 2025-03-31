%{
mergePSD.m - A MATLAB script for merging and aligning power spectral density (PSD) data from two datasets.

It demonstrates how to:
1. Load and process PSD data from two sources.
2. Align datasets based on their Y-axis values.
3. Merge low-frequency and high-frequency data into a single dataset.

Key Features:
- Handles datasets with different lengths by finding the best alignment offset.
- Slices and merges data based on a specified frequency cutoff.
- Combines data while preserving the integrity of the frequency and PSD values.

Functions:
1. mergeAlighment:
    - Aligns and merges two datasets (low-frequency and high-frequency).
    - Slices data based on a frequency cutoff and aligns them in the Y direction.
    - Outputs merged frequency, PSD, and Y-axis data.

Inputs:
- Two datasets containing frequency (`f`), PSD (`pxx`), and Y-axis (`Y`) values.
- A frequency cutoff (`cut_f`) to separate low and high-frequency data.

Outputs:
- Merged frequency (`f_merge`), PSD (`pxx_merge`), and Y-axis (`Y_merge`) data.

Usage:
- This script is useful for combining PSD data from different measurement ranges or resolutions.
- It can be adapted for other types of data alignment and merging tasks.

Note:
- Ensure the input data files (`pxxs.mat`) contain the required variables (`pxxs`, `fs`, `Y`).
- The script assumes the datasets are stored in specific directories (`C/figure_data` and `L/figure_data`).

%}

clc; clear; close all;
data_c = load("C/figure_data/pxxs.mat");
data_l = load("L/figure_data/pxxs.mat");

pxx_c = data_c.pxxs; f_c = data_c.fs;
% Find the middle index of the data
mid_c = round(size(pxx_c, 2)/2);
pxx_c = squeeze(pxx_c(:, mid_c, :));
f_c = squeeze(f_c(:, mid_c, :));
% Remove high frequency white noise data
out_f = 100; % cut edge of frequency
out_index = f_c(1, :) > out_f;
f_c(:, out_index) = [];
pxx_c(:, out_index) = [];

pxx_l = data_l.pxxs; f_l = data_l.fs;
mid_l = round(size(pxx_l, 2)/2);
pxx_l = squeeze(pxx_l(:, mid_l, :));
f_l = squeeze(f_l(:, mid_l, :));

cut_f = 2; % cut edge of merged frequency
index_c = (f_c >= cut_f);
index_l = (f_l <= cut_f);

Y_c = data_c.Y;
Y_l = data_l.Y;

% Align datasets based on Y-axis values
if length(Y_l) > length(Y_c)
    longer = Y_l;
    shorter = Y_c;
else
    longer = Y_c;
    shorter = Y_l;
end
best_offset = 0;
min_diff = inf;
for offset = 0:(length(longer) - length(shorter))
    current_diff = sum(abs(longer(1+offset:offset+length(shorter)) - shorter));
    if current_diff < min_diff
        best_offset = offset;
        min_diff = current_diff;
    end
end

if length(Y_l) > length(Y_c)
    [f_merge, pxx_merge, Y_merge] = mergeAlighment({f_l, pxx_l, Y_l}, {f_c, pxx_c, Y_c}, cut_f, best_offset);
else
    [f_merge, pxx_merge, Y_merge] = mergeAlighment({f_c, pxx_c, Y_c}, {f_l, pxx_l, Y_l}, cut_f, best_offset);
end

save('merged_pxx.mat', 'f_merge', 'pxx_merge', 'Y_merge');

function [f_merge, pxx_merge, Y_merge] = mergeAlighment(longer, shorter, cut_f, offset)
    if max(longer{1}, [], "all") < max(shorter{1}, [], "all")
        low_freq_data = longer;
        high_freq_data = shorter;
        [f_l, pxx_l, Y_l] = low_freq_data{:};
        [f_c, pxx_c, Y_c] = high_freq_data{:};
        % Slice low frequency data to align with high frequency data in Y direction
        pxx_l = pxx_l(offset+1:offset+length(Y_c), :);
        f_l = f_l(offset+1:offset+length(Y_c), :);
        Y_l = Y_l(offset+1:offset+length(Y_c), :);
    else
        low_freq_data = shorter;
        high_freq_data = longer;
        [f_l, pxx_l, Y_l] = low_freq_data{:};
        [f_c, pxx_c, Y_c] = high_freq_data{:};
        % Slice high frequency data to align with low frequency data in Y direction
        pxx_c = pxx_c(offset+1:offset+length(Y_l), :);
        f_c = f_c(offset+1:offset+length(Y_l), :);
        Y_c = Y_c(offset+1:offset+length(Y_l), :);
    end
    Y_merge = mean([Y_l, Y_c], 2);

    % Preallocate memory for f_merge and pxx_merge
    max_columns = size(f_l, 2) + size(f_c, 2); % Maximum possible columns
    f_merge = zeros(length(Y_merge), max_columns);
    pxx_merge = zeros(length(Y_merge), max_columns);

    % Slice low frequency data based on cut_f
    for ii = 1:length(Y_merge)
        index_l = (f_l(ii, :) <= cut_f);
        index_c = (f_c(ii, :) >= cut_f);
        merged_f = [f_l(ii, index_l) f_c(ii, index_c)];
        merged_pxx = [pxx_l(ii, index_l) pxx_c(ii, index_c)];
        assert(length(merged_f) == length(merged_pxx), "Length mismatch between frequency and PSD data.");
        
        % Store merged data
        f_merge(ii, 1:length(merged_f)) = merged_f;
        pxx_merge(ii, 1:length(merged_pxx)) = merged_pxx;
        plot(f_c(ii, :), pxx_c(ii, :));
        hold on;
        plot(f_l(ii, :), pxx_l(ii, :));
        plot(merged_f, merged_pxx); 
        set(gca, 'XScale', 'log', 'YScale', 'log'); hold off;
    end

    % Trim unused columns
    f_merge = f_merge(:, 1:length(merged_f));
    pxx_merge = pxx_merge(:, 1:length(merged_pxx));
end