clc;
% clear;
clearvars -except z
close all;
format shortG;

%% Parameters Definition
global NFE;
NFE = 0; % Number of fitness evaluations.

data = load('data.mat'); % Load path planning data

nvar = data.nvar; % Number of variables
lb = data.LB;     % Lower Bound
ub = data.UB;     % Upper Bound      

maxiter = 20;          % Maximum Number of iterations

Np = 20;               % Number of Bacteria
Ns = 2;                % Swim Length
Nc = 30;               % Number of Chemotaxis Steps
Nr = 4;                % Number of Reproduction Steps
Ne = 4;                % Number of Elimination-Dispersal Events
Ped = 0.5;             % Elimination-Dispersal Probability
C = 0.8;               % Step size

%% Initialization
emp.x = [];
emp.SCH = [];
emp.info = [];
emp.fit = [];

pop = repmat(emp, Np, 1);

for i = 1:Np
    pop(i).x = unifrnd(lb, ub);  % Initialize bacteria positions
    pop(i) = fitness(pop(i), data);
end

[~, ind] = min([pop.fit]);  % Sorting solutions based on their fitness
gpop = pop(ind);            % Best Solution So far

%% Main Loop

% Initialize the structure array with matching fields to avoid errors
gpopArray(maxiter) = emp;
BEST = zeros(maxiter, 1);
MEAN = zeros(maxiter, 1);
tic;

for Loopiter = 1:maxiter

    for iter = 1:Ne
        for rep = 1:Nr
            Jchem = zeros(Np, Nc + 1); % Initialize Jchem matrix
            Jchem(:, 1) = [pop.fit]'; % First column of Jchem is the initial fitness
            
            for chem = 1:Nc
                % Chemotaxis Loop %
                for i = 1:Np
                    del = (rand(1, nvar) - 0.5) * 2; % Random direction
                    pop(i).x = pop(i).x + (C / sqrt(sum(del.^2))) * del; % Tumble
                    pop(i).x = min(max(pop(i).x, lb), ub);
    
                    pop(i) = fitness(pop(i), data);
                    m = 0;
                    while m < Ns
                        m = m + 1;
                        if pop(i).fit < gpop.fit
                            gpop = pop(i);
                            pop(i).x = pop(i).x + C * (del / sqrt(sum(del.^2))); % Swim
                            pop(i).x = min(max(pop(i).x, lb), ub);
                            pop(i) = fitness(pop(i), data);
                        else
                            break; % End of swim
                        end
                    end
                end
                Jchem(:, chem + 1) = [pop.fit]'; % Store the fitness after each chemotactic step
            end
    
            % Calculate Jhealth as the sum of all chemotactic costs for each bacterium
            Jhealth = sum(Jchem, 2); %calculates the sum of the elements in each row
            
            % Sort bacteria and chemotactic parameters
            [~, I] = sort(Jhealth, 'ascend');
            pop = [pop(I(1:Np/2)); pop(I(1:Np/2))];
            gpop = pop(1);
            
        end
    
        % Elimination-Dispersal
        for i = 1:Np
            if rand < Ped
                pop(i).x = unifrnd(lb, ub);
                pop(i) = fitness(pop(i), data);
            end
        end
    
        % Update Best Solution
        [minpop, ind] = min([pop.fit]);

        if minpop < gpop.fit 
            % Ensuring that Elimination dispersal did not eliminate the best solution
            gpop = pop(ind);
        end

    end

    % In each iteration, store gpop in the array
    gpopArray(Loopiter) = gpop; % Store the structure
    
    BEST(Loopiter) = gpop.fit;
    MEAN(Loopiter) = mean([pop.fit]);
    
    disp(['Iteration ' num2str(Loopiter) ' Best= ' num2str(BEST(Loopiter))]);
    
end
elapsed_time = toc;
[~, ind] = min(BEST);
gpop = gpopArray(ind);

%% Results
disp(' ');
disp(['BEST fitness = ' num2str(gpop.fit)]);
disp(['Time = ' num2str(elapsed_time)]);

figure(1)
plot(BEST(1:Loopiter), 'r', 'LineWidth', 2);
xlabel('Iteration');
ylabel('Fitness');
legend('BEST');
title('Bacterial Foraging Optimization');

RES(gpop, data);






