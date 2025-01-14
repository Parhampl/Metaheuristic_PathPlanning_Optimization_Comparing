
clc;
clear;
close all;
%%
% Start recording output to a file named "output.txt"
% diary('output.txt');
InitialVariables = {'top_right', 'top_left', 'Secondary_Axis', 'right', 'Main_Axis', 'left', 'down_right', 'down_left' };
 %it just work on the first two elemnt of InitialVariables  

 for f = 1:numel(InitialVariables)

    % Load data from .mat file
    data = load(InitialVariables{f});  % Load data from .mat file
   
    %% Problem Definition
    CostFunction=@(x) egg_holder(x);        % Cost Function
    nVar=2;             % Number of Decision Variables
    VarSize=[1 nVar];   % Decision Variables Matrix Size
    VarMin=-512;         % Lower Bound of Variables
    VarMax= 512;         % Upper Bound of Variables
    %% ICA Parameters
    nPop=60;            % Population Size
    nEmp=10;            % Number of Empires/Imperialists
    alpha=1;            % Selection Pressure
    beta=2;           % Assimilation Coefficient
    pRevolution=0.5;   % Revolution Probability
    mu=0.5;             % Revolution Rate(A parameter that determines the fraction of colonies that will undergo revolution.)
    zeta=0.1;           % Colonies Mean Cost Coefficient
   
    
    
    %% Globalization of Parameters and Settings
    global ProblemSettings; %#ok
        ProblemSettings.CostFunction=CostFunction;
        ProblemSettings.nVar=nVar;
        ProblemSettings.VarSize=VarSize;
        ProblemSettings.VarMin=VarMin;
        ProblemSettings.VarMax=VarMax;
    global ICASettings;  %#ok
        ICASettings.nPop=nPop;
        ICASettings.nEmp=nEmp;
        ICASettings.alpha=alpha;
        ICASettings.beta=beta;
        ICASettings.pRevolution=pRevolution;
        ICASettings.mu=mu;
        ICASettings.zeta=zeta;
    
    %% Initialization
    % positions = [];
    % costs = [];
    
    % Initialize Empires
    [emp,x11,y11]= CreateInitialEmpire_WithKnownInitialCountry(data);
    
    %% Debuging codes 
    %این کد رو از توی فانکشن دراوردم تا ببینم داده ها بدرستی عوض میشن یا نه
    % % Initialize empty country structure
    %     empty_country = struct('Position', [], 'Cost', []);
    %     
    %     % Initialize country structure
    %     country = repmat(empty_country, nPop, 1);
    % 
    % 
    % for i=1:nPop
    %        
    %         country(i).Position = data.x(i,:);
    %         country(i).Cost=CostFunction(country(i).Position);
    %         x11(i)=country(i).Position(1);
    %         y11(i)=country(i).Position(2);
    % end
    % for y = 1:nPop
    %         fprintf('country(%d).Position = [%s]\n', y, num2str(country(y).Position));
    % end
    
    
    % % Loop over emp array to collect positions and costs
    % for k = 1:numel(emp)
    %     positions = [positions; emp(k).Imp.Position];
    %     costs = [costs; emp(k).Imp.Cost];
    % end
    % 
    % % Display positions and costs
    % fprintf('Positions:\n');
    % disp(positions);
    % fprintf('Costs:\n');
    % disp(costs);
    
    %% ICA Main Loop
    disp(' ')
    Header = InitialVariables{f};
    fprintf('<strong>%s</strong>\n', Header);    
    [e,elapsed_time, imp_up, emp, BestCost, BestSol, Best] = ICAMainLoop(emp);
    
    
    %% Results
    
    nEmp=numel(emp);
    Answer = BestSol.Cost;
    bestx=BestSol.Position(1); besty=BestSol.Position(2);
    
    disp(['best solution x '  num2str(bestx)    'best solution y'  num2str(besty)]);
    disp(['BestSol  ', num2str(Answer)]);
    disp(['Elapsed time is ', num2str(elapsed_time)]);
    disp(['No.Iterations  ', num2str(e)]);
    disp(' ')
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
            f(i)=-x1(j)*sin(sqrt(abs(x1(j)-x2(i)-47)))-(x2(i)+47)*sin(sqrt(abs(0.5*x1(j)+x2(i)+47))); %#ok
      %objective function 
        end
        
        f_tot(j,:)=f; %#ok
    
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
    z11=1000*ones(nPop,1);
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
    x22 = [];
    y22 = [];
    for i=1:nEmp
        x22(i,1)=emp(i).Imp.Position(1); %#ok
        y22(i,1)=emp(i).Imp.Position(2); %#ok
    end
     for k=1:nEmp
            for i=1:emp(k).nCol
                x22=[x22;emp(k).Col(i).Position(1)]; %#ok
                y22=[y22;emp(k).Col(i).Position(2)]; %#ok
            end
     end
        
    z22=1000*ones(nPop,1);
    scatter3(x22,y22,z22,'filled')
    xlabel('solution')
    title('final condition')
    hold off
    %best answer in every iteration plotting
    
    figure(2);
    %plot(BestCost,'LineWidth',2);
    semilogy(BestCost);
    xlabel('Iteration');
    ylabel('Best Cost');
    grid on;

 end

% diary off;
