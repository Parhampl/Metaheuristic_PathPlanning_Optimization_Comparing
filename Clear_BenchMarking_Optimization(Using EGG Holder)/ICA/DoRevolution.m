function emp=DoRevolution(emp)
    global ProblemSettings;
    CostFunction=ProblemSettings.CostFunction;
    VarSize=ProblemSettings.VarSize;
    VarMin=ProblemSettings.VarMin;
    VarMax=ProblemSettings.VarMax;
    
    global ICASettings;
    pRevolution=ICASettings.pRevolution;
    mu=ICASettings.mu;

    
    sigma=0.4*(VarMax-VarMin);
    nEmp=numel(emp);

    for i=1:nEmp
        nmu(i)=ceil(mu*emp(i).nCol);
        rands(i).rands=randperm(emp(i).nCol);
    end
    for k=1:nEmp
        for i=1:nmu(k)
                NewPos = emp(k).Col(rands(k).rands(i)).Position + sigma*randn(VarSize);    
             if rand<=pRevolution
                emp(k).Col(rands(k).rands(i)).Position(:) = NewPos(:);
                for j=1:emp(k).nCol
                emp(k).Col(j).Position = max(emp(k).Col(j).Position,VarMin);
                emp(k).Col(j).Position = min(emp(k).Col(j).Position,VarMax);
                emp(k).Col(j).Cost = CostFunction(emp(k).Col(j).Position);
                end
             end
        end
    end
end