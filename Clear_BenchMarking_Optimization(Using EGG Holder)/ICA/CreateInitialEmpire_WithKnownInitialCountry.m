function [emp,x11,y11] = CreateInitialEmpire_WithKnownInitialCountry(data)
%% Global Variables
    global ProblemSettings;
    global ICASettings;
    CostFunction=ProblemSettings.CostFunction;
    nVar=ProblemSettings.nVar;
    VarSize=ProblemSettings.VarSize;
    VarMin=ProblemSettings.VarMin;
    VarMax=ProblemSettings.VarMax;
    
    nPop=ICASettings.nPop;
    nEmp=ICASettings.nEmp;
    nCol=nPop-nEmp;
    alpha=ICASettings.alpha;

%% Initialize Countries
    % Initialize empty country structure
    empty_country = struct('Position', [], 'Cost', []);
    
    % Initialize country structure
    country = repmat(empty_country, nPop, 1);


    for i=1:nPop
           
            country(i).Position = data.x(i,:);
            country(i).Cost=CostFunction(country(i).Position);
            x11(i)=country(i).Position(1);
            y11(i)=country(i).Position(2);
    end

    costs=[country.Cost];
    [~, SortOrder]=sort(costs);
    country=country(SortOrder);
        
    imp=country(1:nEmp);
        
    col=country(nEmp+1:end);


    empty_empire.Imp=[];
    empty_empire.Col=repmat(empty_country,0,1);
    empty_empire.nCol=0;
    empty_empire.TotalCost=[];
        
    emp=repmat(empty_empire,nEmp,1);
        
    % Assign Imperialists
    for k=1:nEmp
            emp(k).Imp=imp(k);
    end
        
    % Assign Colonies
    P=exp(-alpha*[imp.Cost]/max([imp.Cost]));
    P=P/sum(P);
    for j=1:nCol
            
            k=RouletteWheelSelection(P);
            
            emp(k).Col=[emp(k).Col
                        col(j)];
            
            emp(k).nCol=emp(k).nCol+1;
    end
        
    emp=UpdateTotalCost(emp);

end
    