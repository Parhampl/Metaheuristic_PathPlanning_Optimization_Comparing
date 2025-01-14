
function emp=IntraEmpireCompetition(emp)
    nEmp=numel(emp);
    VarMax=512;
    VarMin=-512;
    CostFunction=@(x) egg_holder(x); 
    
    for k=1:nEmp
        for i=1:emp(k).nCol
            if emp(k).Col(i).Cost<emp(k).Imp.Cost
                imp=emp(k).Imp;
               
                col=emp(k).Col(i);
                
                emp(k).Imp=col;
                emp(k).Col(i)=imp;

            end
            end
        end
end