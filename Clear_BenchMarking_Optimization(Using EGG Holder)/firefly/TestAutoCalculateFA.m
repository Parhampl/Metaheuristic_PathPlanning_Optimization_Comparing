clear;
clc;
close all;
%% Start recording output to a file named "output.txt"
% diary('output.txt');
InitialVariables = {'top_right', 'top_left', 'Secondary_Axis', 'right', 'Main_Axis', 'left', 'down_right', 'down_left'};

for i = 1:numel(InitialVariables)
%% parameters
n=60;                   % Population size (number of fireflies)
alpha=0.9;              % Randomness strength 0--1 (highly random)
beta0=1;              % Attractiveness constant
gamma=0.01;             % Absorption coefficient
theta=0.9;             % Randomness reduction factor theta=10^(-5/tMax) 
d=2;                   % Number of dimensions
Lb=-512*ones(1,d);       % Lower bounds/limits
Ub=512*ones(1,d);        % Upper bounds/limits
%% preallocating
ns=zeros(n,d); %soloutions
Lightn=zeros(1,n); %fitness
x11=zeros(n,1); %initial soloutions for plotting
y11=zeros(n,1);
x22=zeros(n,1);%final soloutions for plotting
y22=zeros(n,1);
e=1; %for counting iterations
mins=0; %for minimums of each iteration
f=zeros(1,1501);
f_tot=zeros(1501,1501); %for plotting


%% Load data from .mat file
    data = load(InitialVariables{i});
    ns = double(data.x); % Assuming the variable 'x' contains the data you need
    Lightn(i)=egg_holder(ns(i, :));               % Evaluate objectives


 %% Initial swarm
    for j = 1:n
        x11(j, 1) = ns(j, 1);
        y11(j, 1) = ns(j, 2);
    end

    % Call optimization function
    [e, elapsed_time, fbest, nbest, mins, ns] = FireFly_Optimization(n, alpha, beta0, gamma, theta, d, Lb, Ub, ns, Lightn, x11, y11, x22, y22, e, mins, f_tot);

%% Results
    % Print results
    disp(['Variable: ' InitialVariables{i}]);
    disp(' ');
    disp(['Best fitness =  ' num2str(fbest)]);
    disp(['Best solution =  ' num2str(nbest)]);
    disp(['Time =  ' num2str(elapsed_time)]);
    disp(['No.Iteration= ' num2str(e)])
    disp(' ');



    % Plotting
    x1min = -512;
    x1max = 512;
    x2min = -512;
    x2max = 512;
    R = 1500; % Steps resolution
    x1 = x1min:(x1max - x1min) / R:x1max;
    x2 = x2min:(x2max - x2min) / R:x2max;

    for j = 1:length(x1)
        for i = 1:length(x2)
            f(i) = -x1(j) * sin(sqrt(abs(x1(j) - x2(i) - 47))) - (x2(i) + 47) * sin(sqrt(abs(0.5 * x1(j) + x2(i) + 47)));
        end
        f_tot(j, :) = f;
    end

    figure(1)
    nexttile
    mesh(x1, x2, f_tot); view(0, 90); colorbar; set(gca, 'FontSize', 12);
    xlabel('x_2', 'FontName', 'Times', 'FontSize', 20, 'FontAngle', 'italic');
    ylabel('x_1', 'FontName', 'Times', 'FontSize', 20, 'FontAngle', 'italic');
    zlabel('f(X)', 'FontName', 'Times', 'FontSize', 20, 'FontAngle', 'italic');
    title('X-Y Plane View', 'FontName', 'Times', 'FontSize', 24, 'FontWeight', 'bold');
    hold on
    z11 = 1000 * ones(n, 1);
    scatter3(x11, y11, z11, 'filled');
    title('Initial Condition');
    hold off

    nexttile
    mesh(x1, x2, f_tot); view(0, 90); colorbar; set(gca, 'FontSize', 12);
    xlabel('x_2', 'FontName', 'Times', 'FontSize', 20, 'FontAngle', 'italic');
    ylabel('x_1', 'FontName', 'Times', 'FontSize', 20, 'FontAngle', 'italic');
    zlabel('f(X)', 'FontName', 'Times', 'FontSize', 20, 'FontAngle', 'italic');
    title('X-Y Plane View', 'FontName', 'Times', 'FontSize', 24, 'FontWeight', 'bold');
    hold on
    for i = 1:n
        x22(i, 1) = ns(i, 1);
        y22(i, 1) = ns(i, 2);
    end
    z22 = 1000 * ones(n, 1);
    scatter3(x22, y22, z22, 'filled');
    title('Final Condition');
    hold off

    figure(2)
    t = 1:e;
    plot(t, mins, '-');
    xlabel('iterations');
    ylabel('optimum');
    grid
end

% Stop recording
% diary off;

