clear
clc
close all;

%% Defining Parameters

%   Control parameters of EFO
populationSize = 60;                        %   Population size, (M)
x = 0.99999;                                  %   Balances the magnitudes of current frequency and old amplitude values
activeIndSize =21;                         %   Subpopulation size, (K)
thres = 1e-5;                               %   A small constant value


%   Problem specific parameters
lowerBound = -512;            %   Lower limit of the problem, (x_maxj)
upperBound = 512;            %   Upper limit of the problem, (x_minj)
parameterSize = 2;      %   Parameter size to be optimized, (d)
fMin = -959.6407;                        %   Global minimum of the problem

%   Initially all individuals are first initialized in the range of [x_maxj,
%   x_minj] then their fitness values are calculated (see Sect. 2.3.1)

bests=0; %minimum of each iteration
f=zeros(1,1501);
f_tot=zeros(1501,1501); %for plotting
e=1; %to count the number of iterations
%defining initial and final swarm condition for plotting

%% preallocating
population=struct('solution',cell(1,populationSize),'fitness',cell(1,populationSize),'isActive',cell(1,populationSize), ...
    'frequency',cell(1,populationSize),'amplitude',cell(1,populationSize));
%% initializing


for p = 1 : populationSize
    
    population(p).solution = lowerBound + (upperBound - lowerBound) * rand(1, parameterSize);
    population(p).fitness = egg_holder(population(p).solution(1),population(p).solution(2));
    population(p).isActive = true;
    
end

populationinitial=population; %initial swarm

%   The best individual information is stored
[bestCost, index] = min( [population(:).fitness] );
bestIndividual = population(index).solution;

%   The worst individual information is also stored for frequency calculation
[worstCost, index] = max( [population(:).fitness] );
worstIndividual = population(index).solution;

globalBest = bestCost; %minimum cost
globalBestSol = bestIndividual; %the solution for minimum cost

%   Frequency (f) and amplitude (A) values are also initialized
for p = 1 : populationSize
    
    if std([population(:).fitness]) < thres 
        
        population(p).frequency = rand;
        
    else
        
        population(p).frequency = (worstCost - population(p).fitness) / (worstCost - bestCost);
        
    end
    
    population(p).amplitude = population(p).frequency;
    
end
   
%% optimization
%   Beginning of the optimization process
tic
while globalBest-fMin>0.01 %exit condition
 for p = 1 : populationSize  %   For every individual do,
      newIndividual = population(p);  %   ith individual, (i)
      neighborIndividual = population;
      neighborIndividual(p) = []; %   Neighbors of i, (N - {i})
        
        if (newIndividual.frequency > rand) %   Active electrolocation phase (see Sect. 2.3.2)
            
            population(p).isActive = true;  %   Broadcasts other individuals that ith individual will be in active mode
            newIndividual.solution = activeSearch(newIndividual, neighborIndividual, lowerBound, upperBound);   %   Performs search through active electrolocation
         else    %   Passive electrolocation phase (see Sect. 2.3.3)
            
            population(p).isActive = false; %   Broadcasts other individuals that ith individual will be in passive mode
            activePopulation = neighborIndividual( [neighborIndividual(:).isActive] );  %   Actively electrolocating individuals, (N_A)
            
            if ~isempty(activePopulation) %defining passive ones
                
                newIndividual.solution = passiveSearch(newIndividual, activePopulation, activeIndSize); %   Performs search through passive electrolocation
                
            end
            
            if rand < rand %   Mutates oner more paramete in a stochastic manner to keep the population diverse
                I = randi(parameterSize);
                newIndividual.solution(I) = lowerBound + (upperBound - lowerBound) * rand; %random new individual
            end
        end
        newIndividual.solution = boundaryCheck(newIndividual.solution, lowerBound, upperBound); %   Solution set of candidate individual, (x_cand)
         newIndividual.fitness = egg_holder(newIndividual.solution(1),newIndividual.solution(2));   %   Fitness value of candidate individual
        if  newIndividual.fitness < population(p).fitness   %   Accepts if better source found
            population(p) = newIndividual;
        end 
 end
 %   The best individual information is stored
    [bestCost, index] = min( [population(:).fitness] );
    bestIndividual = population(index).solution;
    
    %   The worst individual information is also stored for frequency calculation
    [worstCost, index] = max( [population(:).fitness] );
    worstIndividual = population(index).solution;

     %   Frequency (f) and amplitude (A) values are updated
    for p = 1: populationSize
        
        if std([population(:).fitness]) < thres
            
            population(p).frequency = rand;
            
        else
            
            population(p).frequency = (worstCost - population(p).fitness) / (worstCost - bestCost);
            
        end
        
        population(p).amplitude = population(p).amplitude * (x) + population(p).frequency * (1 - x);
        
    end
    
    
    if bestCost < globalBest   %   The best cost and solution found so far are stored
        
        globalBest = bestCost;
        globalBestSol = bestIndividual;
        
    end
    bests=[bests , globalBest];
    
%   End of the iteration
e=e+1;
end
toc
%% results
%printing final results
disp(['best fitness =  ' num2str(globalBest)]);
disp(' ');
disp(['best solution =  ' num2str(globalBestSol)]);
%% plotting
% egg holder plot
warning off

x1min=-512;
x1max=512;
x2min=-512;
x2max=512;
R=1500; % steps resolution
x1=x1min:(x1max-x1min)/R:x1max;
x2=x2min:(x2max-x2min)/R:x2max;    

for j=1:length(x1)
    
    for i=1:length(x2)
        f(i)=-x1(j)*sin(sqrt(abs(x1(j)-x2(i)-47)))-(x2(i)+47)*sin(sqrt(abs(0.5*x1(j)+x2(i)+47)));
  %objective function 
    end
    
    f_tot(j,:)=f;

end

% 1-dimensional plot is not applicable with this benchmark function



figure(1)
nexttile %contour plotting
mesh(x1,x2,f_tot);view(0,90);colorbar;set(gca,'FontSize',12);
xlabel('x_2','FontName','Times','FontSize',20,'FontAngle','italic');
ylabel('x_1','FontName','Times','FontSize',20,'FontAngle','italic');
zlabel('f(X)','FontName','Times','FontSize',20,'FontAngle','italic');
title('X-Y Plane View','FontName','Times','FontSize',24,'FontWeight','bold');
hold on
% initial fish swarm plotting
x11=zeros(populationSize,1);
y11=zeros(populationSize,1);
for i=1:populationSize
x11(i,1)=(populationinitial(i).solution(1));
y11(i,1)=(populationinitial(i).solution(2));
end
z11=1000*ones(populationSize,1);
scatter3(x11,y11,z11,'filled') %initial swarm
xlabel('solution')
title('initial condition')
hold off
nexttile
%contour plotting
mesh(x1,x2,f_tot);view(0,90);colorbar;set(gca,'FontSize',12);
xlabel('x_2','FontName','Times','FontSize',20,'FontAngle','italic');
ylabel('x_1','FontName','Times','FontSize',20,'FontAngle','italic');
zlabel('f(X)','FontName','Times','FontSize',20,'FontAngle','italic');
title('X-Y Plane View','FontName','Times','FontSize',24,'FontWeight','bold');
hold on
%final fish swarm plotting
x22=zeros(populationSize,1);
y22=zeros(populationSize,1);
for i=1:populationSize
x22(i,1)=(population(i).solution(1));
y22(i,1)=(population(i).solution(2));
end
z22=1000*ones(populationSize,1);
scatter3(x22,y22,z22,'filled')
xlabel('solution')
title('final condition')
hold off
%best answer in every iteration plotting
figure(2)
t=1:e;
plot(t,(bests),'-');
xlabel('iterations')
ylabel('optimum')
grid