clear;
clc;
%%
% Egg Holder function plot
warning off

% Define the range for x1 and x2
x1min = -512;
x1max = 512;
x2min = -512;
x2max = 512;

% Steps resolution
R = 1500;

% Generate values for x1 and x2
x1 = linspace(x1min, x1max, R);
x2 = linspace(x2min, x2max, R);

% Initialize f_tot matrix for storing function values
f_tot = zeros(R, R);

% Calculate the Egg Holder function for each (x1, x2) pair
for j = 1:length(x1)
    for i = 1:length(x2)
        f(i) = -x1(j) * sin(sqrt(abs(x1(j) - x2(i) - 47))) - (x2(i) + 47) * ...
               sin(sqrt(abs(0.5 * x1(j) + x2(i) + 47)));
    end
    f_tot(j, :) = f;
end

% 3D mesh plot of the Egg Holder function
figure;
mesh(x1, x2, f_tot);

% Configure the view and labels
view(45, 30); % Adjust view angle for better visualization
colorbar; % Display a color bar for reference
set(gca, 'FontSize', 12);
xlabel('x_1', 'FontName', 'Times', 'FontSize', 20, 'FontAngle', 'italic');
ylabel('x_2', 'FontName', 'Times', 'FontSize', 20, 'FontAngle', 'italic');
zlabel('f(x_1, x_2)', 'FontName', 'Times', 'FontSize', 20, 'FontAngle', 'italic');
title('Eggholder Function', 'FontName', 'Times', 'FontSize', 24, 'FontWeight', 'bold');
