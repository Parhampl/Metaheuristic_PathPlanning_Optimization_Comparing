function [e, elapsed_time , imp_up, emp, BestCost, BestSol, Best] = ICAMainLoop(emp)

    %% Globalization of Parameters and Settings
    global ProblemSettings; %#ok
    CostFunction=@(x) egg_holder(x);        % Cost Function
%     nVar = ProblemSettings.nVar;
%     VarSize = ProblemSettings.VarSize;
    VarMin = ProblemSettings.VarMin;
    VarMax = ProblemSettings.VarMax;

%     global ICASettings;
%     nPop = ICASettings.nPop;
%     nEmp = ICASettings.nEmp;
%     alpha = ICASettings.alpha;
%     beta = ICASettings.beta;
%     pRevolution = ICASettings.pRevolution;
%     mu = ICASettings.mu;
%     zeta = ICASettings.zeta;

    %% Initialization of Variables
    Best = 0;
    e = 1;
    BestCost = [];
    BestSol.Position = [];
    BestSol.Cost = [];



    %% moshkelat:
%Imp_Ex ba emp teki nist
  %%
tic;
    while abs(Best + 959.6407) > 0.01
        % Assimilation
        emp = AssimilateColonies(emp);
        
        % Revolution
        emp = DoRevolution(emp);
        
        % Intra-Empire Competition
        emp = IntraEmpireCompetition(emp);
        
        % Update Total Cost of Empires
        emp = UpdateTotalCost(emp);
        
        % Inter-Empire Competition
        emp = InterEmpireCompetition(emp);
        
        nEmp = numel(emp);
        for k = 1:nEmp
            for i = 1:emp(k).nCol
                emp(k).Col(i).Position = max(emp(k).Col(i).Position, VarMin);
                emp(k).Col(i).Position = min(emp(k).Col(i).Position, VarMax);

                emp(k).Col(i).Cost = CostFunction(emp(k).Col(i).Position);
                emp(k).Imp.Position = max(emp(k).Imp.Position, VarMin);
                emp(k).Imp.Position = min(emp(k).Imp.Position, VarMax);
                emp(k).Imp.Cost = CostFunction(emp(k).Imp.Position);   
            end
        end
             % Update Best Solution Ever Found

             
        imp_up=[emp.Imp];
        [~, BestImpIndex]=min([imp_up.Cost]);
        BestSol=imp_up(BestImpIndex);
        
        % Update Best Cost
        BestCost(e)=BestSol.Cost; %#ok
        
        % Show Iteration Information
      
%         disp(['Iteration ' num2str(e) ': Best Cost = ' num2str(BestCost(e))]);
        Best=BestCost(e);
       
        e=e+1;

%         % Update Best Solution Ever Found
%         Imp_EX_2 = repmat(Imp_EX,nEmp,1);
% 
%         Imp_EX_2 = [emp.Imp];
%         [~, BestImpIndex] = min([Imp_EX_2.Cost]);
%         BestSol = Imp_EX_2(BestImpIndex);
% 
%         % Update Best Cost
%         BestCost(e) = BestSol.Cost;
% 
%         Best = BestCost(e);
% 
% 
%         % Show Iteration Information
%         disp(['Iteration ' num2str(e) ': Best Cost = ' num2str(Best)]);
% 
%         e = e + 1;
    end
    elapsed_time = toc;
end
