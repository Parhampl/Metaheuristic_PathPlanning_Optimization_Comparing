
clear;
clc;
close all;
% Start recording output to a file named "output.txt"
% diary('output.txt');
InitialVariables = {'top_right', 'top_left', 'Secondary_Axis', 'right', 'Main_Axis', 'left', 'down_right', 'down_left' };
for i = 1:numel(InitialVariables)
    % Load data from .mat file
    data = load(InitialVariables{i});
    nest = double(data.x);  % Assuming the variable 'x' contains the data you need
    
    %% parameters
    % Number of nests (or different solutions)
    n = 60;
    % Discovery rate of alien eggs/solutions
    pa = 0.75;
    % Lower bounds
    nd = 2; 
    Lb = -512 * ones(1, nd);
    % Upper bounds
    Ub = 512 * ones(1, nd);
    % Random initial solutions
    %% preallocating
    x11 = zeros(n, 1);
    y11 = zeros(n, 1);
    x22 = zeros(n, 1);
    y22 = zeros(n, 1);
    mins1 = 0; % minimum of each iteration
    f = zeros(1, 1501);
    f_tot = zeros(1501, 1501); % for plotting
    e = 1; % to count the number of iterations
    
    %% Change this if you want to get better results
    % Tolerance
    Tol = 1.0e-2;
    disp(InitialVariables{i});
    % Call cuckoo_optimization with loaded data and other parameters
    [e, best, fmin, elapsed_time, x11, y11, mins1] = cuckoo_optimization(nest, n, pa, Lb, Ub, Tol, mins1, e);
end
% Stop recording
% diary off;