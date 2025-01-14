clc;
clear;
close all;

%% Start recording output to a file named "output.txt"
diary('output.txt');
InitialVariables = {'top_right', 'top_left', 'Secondary_Axis', 'right', 'Main_Axis', 'left', 'down_right', 'down_left'};


for f = 1:numel(InitialVariables)
%% Problem Definition

CostFunction = @(x) egg_holder(x);  %Cost Function

nVar = 2;                       % Number of Decision Variables

VarSize = [1, nVar];            %Decision Variable Matrix Size

VarMin = -512;                   %Decision Variables Lower Boundary

VarMax = 512;                    %Decision Variables Upper Boundary

%% FireFly Algorithm Parameters
nPop = 60; % number of Fireflies (Swarm Size)

gamma =1;  %Light absoprtion coefficient


betaO = 2; %Attraction coefficient Base Value


alpha = 0.9; %Mutation Vector Coefficient

alpha_damp = 0.9;  %MutATION COEFFICIENT Damp


delta = 0.1*(VarMax - VarMin);  %Uniform Mutation Range

m = 2;   %Power of Distance

counter = 1;   %Iteration number

%% Load data from .mat file
 data = load(InitialVariables{f});


%% Initialization

% Empty Firefly Structure
firefly = struct('Position', [], 'Cost', []);
BestSol = struct('Position', [], 'Cost', []);
%Initialize Best Solution ever Found
BestSol.Cost = inf;

%Initialize Population Array
firefly = repmat(firefly, nPop, 1);
for k= 1:nPop
    firefly(k).Position = data.x(k,:);
    firefly(k).Cost = CostFunction(firefly(k).Position);

    if firefly(k).Cost <= BestSol.Cost
        BestSol = firefly(k);
    end
end
BestCostPosition = [];
BestCost = [];
%% Firefly Algorithm Main Loop
tic;
while BestSol.Cost + 959.6407 > 0.01 % Exit condition

    newfirefly = firefly;
    for i = 1:nPop
        for j = 1:nPop
            if firefly(j).Cost<= firefly(i).Cost

                %Define the distance
                rij = norm(firefly(i).Position - firefly(j).Position); 


                %Define epsilon(Randomization Vector)
                e =unifrnd(-delta, +delta, VarSize);

                %Define Beta
                beta = betaO*exp(-gamma*rij^m);

                %New Firefly
                newfirefly(i).Position = firefly(i).Position + ...
                    beta* (firefly(j).Position - firefly(i).Position)...
                    + alpha*e;

                %Making Sure that new Positions are inside the Boundries
                newfirefly(i).Position = min(VarMax, newfirefly(i).Position);
                newfirefly(i).Position = max(VarMin, newfirefly(i).Position);

                newfirefly(i).Cost = CostFunction(newfirefly(i).Position);

                %Since some of our answer may be replaced So we Should Save
                %Best answer
                    if BestSol.Cost>=newfirefly(i).Cost
                        BestSol = newfirefly(i);
                    end
            end
        
        end

    end
% Since our firefly and new firefly are different Position and BestSol
% might be replaced during the foor loop, we Should integrate all these
% Structure to extract the global optimum

%Merge
    firefly = [firefly;
               newfirefly;
               BestSol]; %#ok

%Unique
[~, uniqueIdx] = unique([firefly.Cost], 'stable');
firefly = firefly(uniqueIdx);

%Sort

[~, SortedIndex] = sort([firefly.Cost]);
firefly = firefly(SortedIndex);

%Truncate(jamiaat ezafi ro pak mikonim]
firefly = firefly(1:nPop);

%Store Best Cost ever found

BestCost(counter, :)= BestSol.Cost; %#ok
BestCostPosition(counter, :) = BestSol.Position; %#ok

% disp(['Iteration', num2str(counter), ': BestCost', num2str(BestCost(counter)), ', Position', num2str(BestCostPosition(counter, :))]);

%Damp mutation coefficient
alpha = alpha_damp * alpha;
counter = counter+1;

     if alpha < 1e-4 % To avoid getting stuck in the loop
           alpha = 0.9;

%             for k= 1:nPop
%                 firefly(k).Position = data.x(k,:);
%                 firefly(k).Cost = CostFunction(firefly(k).Position);
%             end
     end

end
elapsed_time = toc;

%% Results
    % Print results
    disp(['Variable: ' InitialVariables{f}]);
    disp(' ');
    disp(['BestCost =  ' num2str(BestCost(counter - 1, :))]);
    disp(['Best Position =  ' num2str(BestCostPosition(counter -1, :))]);
    disp(['Time =  ' num2str(elapsed_time)]);
    disp(' ');

end
diary off;



