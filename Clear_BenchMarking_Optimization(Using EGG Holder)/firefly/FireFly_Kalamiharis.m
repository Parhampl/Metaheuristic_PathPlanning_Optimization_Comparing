clc;
clear;
close all;

%% Problem Definition

CostFunction = @(x) egg_holder(x);  %Cost Function

nVar = 2;                       % Number of Decision Variables

VarSize = [1, nVar];            %Decision Variable Matrix Size

VarMin = -512;                   %Decision Variables Lower Boundary

VarMax = 512;                    %Decision Variables Upper Boundary

%% FireFly Algorithm Parameters
MaxIt = 200; %Maximum number of Iteration

nPop = 60; % number of Fireflies (Swarm Size)

gamma =1;  %Light absoprtion coefficient


betaO = 2; %Attraction coefficient Base Value


alpha = 0.9; %Mutation Vector Coefficient

alpha_damp = 0.9;  %MutATION COEFFICIENT Damp


delta = 0.05*(VarMax - VarMin);  %Uniform Mutation Range

m = 2;   %Power of Distance

counter = 1;   %Iteration number


%% Initialization

% Empty Firefly Structure
firefly = struct('Position', [], 'Cost', []);

%Initialize Best Solution ever Found
BestSol.Cost = inf;

%Initialize Population Array
firefly = repmat(firefly, nPop, 1);
for k= 1:nPop
    firefly(k).Position = unifrnd(VarMin, VarMax, VarSize);
    firefly(k).Cost = CostFunction(firefly(k).Position);

    if firefly(k).Cost <= BestSol.Cost
        BestSol = firefly(k);
    end
end


%Array to Hold BestCost
BestCost = zeros(MaxIt,1);
BestCostPosition = zeros(MaxIt, nVar);

%% Firefly Algorithm Main Loop

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
    firefly = [firefly
               newfirefly
               BestSol]; %#ok

%Sort
[~, SortedIndex] = sort([firefly.Cost]);
firefly = firefly(SortedIndex);

%Truncate(jamiaat ezafi ro pak mikonim]
firefly = firefly(1:nPop);

%Store Best Cost ever found

BestCost(counter)= BestSol.Cost;
BestCostPosition(counter, :) = BestSol.Position;

disp(['Iteration', num2str(counter), ': BestCost', num2str(BestCost(counter)), ', Position', num2str(BestCostPosition(counter, :))]);

%Damp mutation coefficient
alpha = alpha_damp * alpha;
counter = counter+1;

     if alpha < 1e-4 % To avoid getting stuck in the loop
           alpha = 0.9;
%                 for i = 1:nPop
%                     ns(i, :) = Lb + (Ub - Lb) .* rand(1, d); % Randomization
%                     Lightn(i) = egg_holder(ns(i, :)); % Evaluate objectives
%                 end
     end

end

%% Results

figure;
plot(BestCost, 'LineWidth',2);
xlabel('Iteration');
ylabel('Best Cost');



