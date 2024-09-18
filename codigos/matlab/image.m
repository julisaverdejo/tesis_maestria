clear; close all; clc;

data = load("final.txt");
volts = data(:,3);
matrix = reshape(volts, [8, 8])';
min_val = 0;
max_val = 3.2;
normalized_matrix = 255 * (matrix - min_val) / (max_val - min_val);
h = heatmap(normalized_matrix);
colormap(gray);