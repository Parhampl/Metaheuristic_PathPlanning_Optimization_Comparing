clear;
close all;
clc;
% Bacteria Foraging Optimization %
%% Bench Marking
% Start recording output to a file named "output.txt"
% diary('output.txt');
InitialVariables = {'top_right', 'top_left', 'Secondary_Axis', 'right', 'Main_Axis', 'left', 'down_right', 'down_left' };
for h = 1:numel(InitialVariables)
    % Load data from .mat file
    data = load(InitialVariables{h});
    %% parameters
    
    Ne=4; %The number of elimination-dispersal events
    Nr=4;  %The number of reproduction steps
    Nc=30;  %Chemotactic steps
    Np=60; %The number of bacteria in the population
    Ns=2;  %number of swim steps
    D=2;  %search dimension
    C=0.8; %The size of the step taken in the random direction specified by the tumble
    Ped=0.5;  %Elimination-dispersal with probability
    CostFunction=@(v)egg_holder(v); %fitness function
    lb=-512;ub=512; %lower and upper boundaries
    %% preallocating
    J=zeros(Np,1);
    Jhealth=zeros(Np,1);
    Jmin=zeros(1,Ne);
    best=0;
    f=zeros(1,1501);
    f_tot=zeros(1501,1501); %for plotting
    e=1; %to count the number of iteration
    min2=0; %minimum fitness for every iteration for plotting
    x11=zeros(Np,1);
    y11=zeros(Np,1);
    x22=zeros(Np,1);
    y22=zeros(Np,1);
    %% initialization
    x=data.x;
    for i=1:Np %for plotting
        x11(i,1)=x(i,1);
        y11(i,1)=x(i,2);
    end
    for k=1:Np 
        v= x(k,:); %initial population 
        J(k)=CostFunction(v); % initial fitness calculation
        
    end
    Jlast=J; %to save this value, since we may find a better cost during a run
    %% optimization
    tic
    while best+959.6407>0.01 %exit condition
    for iter=1:Ne %elimination
        for k=1:Nr %reproduction
            Jchem=J; %for calculating Jhealth 
            for j=1:Nc
                % Chemotaxis Loop %
                
                for i=1:Np
                    del=(rand(1,D)-0.5)*2; %random vector
                    x(i,:)=x(i,:)+(C/sqrt(del*del'))*del; %step of size in the direction of the tumble for bacterium i.
                    v= x(i,:); 
                    v(v>ub)=ub;v(v<lb)=lb; %boundary check
                    x(i,:)=v;
                    J(i)=CostFunction(v); 
                    m=0;
                    while m<Ns %counter for swim length
                        m=m+1;
                        if J(i)<Jlast(i) %choosing the better value
                            Jlast(i)=J(i);
                            x(i,:)=x(i,:)+C*(del/sqrt(del*del'));
                            v= x(i,:);
                            v(v>ub)=ub;v(v<lb)=lb;
                            x(i,:)=v;
                            J(i)=CostFunction(v);
                        else
                            m=Ns; %end of swimming
                        end
                    end
                    
                end
                
                Jchem=[Jchem J]; %#ok
            end  % End of Chemotaxis %
            
            
            for i=1:Np
                Jhealth(i)=sum(Jchem(i,:)); % sum of cost function of all chemotactic loops for a given k & l
            end
            %Sort bacteria and chemotactic parameters
            [Jhealth1,I]=sort(Jhealth,'ascend'); %higher cost means lower health
            %The S bacteria with the highest health values die and the 
            % remaining S bacteria with the best values split
            x=[x(I(1:Np/2),:);x(I(1:Np/2),:)]; 
            J=[J(I(1:Np/2),:);J(I(1:Np/2),:)];
            xmin=x(I(1),:); %best soloution so far
        end
        if iter>1
            if min(J)<Jmin(iter-1)
                [Jmin(iter),loc]=min(J);
                sol=x(loc,:);
            else
                Jmin(iter)=Jmin(iter-1);
            end
        else
            [Jmin,loc]=min(J);
            sol=x(loc,:); 
        end
        % random elimination dispersion
        % keeping the number of bacteria in the population constant
        for i=1:Np
            r=rand;
            if r>=Ped %elimination probability
                x(i,:)=rand(1,D)*(ub-lb)+lb; %random new position
                v= x(i,:);
                J(i)=CostFunction(v);
            end
        end
        
        %end of elimination
    end
    % plot(Jmin);
    best=Jmin(end); %optimum in each iteration
    min2=[min2 , best]; %#ok %optimum in every iteration\
    e=e+1; %counting iterations
    end
    toc
    %% results
    %printing final results
    [sorts,Is]=sort(J);
    for i=1:Np
        sortings(i,1)=x(Is(i),1);%#ok
        sortings(i,2)=x(Is(i),2);%#ok
    end

    disp(' ');
    disp(['Variables:      ' num2str(InitialVariables{h})]);
    disp(['best fitness =  ' num2str(best)]);
    disp(['best solution =  ' num2str(sol)]);
    disp(['No.Iterations =  ' num2str(e)]);
    disp(' ');
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
    z11=1000*ones(Np,1);
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
    for i=1:Np
        x22(i,1)=x(i,1);
        y22(i,1)=x(i,2);
    end
    z22=1000*ones(Np,1);
    scatter3(x22,y22,z22,'filled')
    xlabel('solution')
    title('final condition')
    hold off
    %best answer in every iteration plotting
    figure(2)
    t=1:e;
    plot(t,(min2),'-');
    xlabel('iterations')
    ylabel('optimum')
    grid
end


% Stop recording
% diary off;

