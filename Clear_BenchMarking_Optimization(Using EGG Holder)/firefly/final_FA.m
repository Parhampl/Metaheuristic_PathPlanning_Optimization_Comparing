clear
clc
close all;

%% parameters
n=60;                   % Population size (number of fireflies)
alpha=0.9;              % Randomness strength 0--1 (highly random)
beta0=1;              % Attractiveness constant
gamma=0.01;             % Absorption coefficient
theta=1;             % Randomness reduction factor theta=10^(-5/tMax) 
d=2;                   % Number of dimensions
Lb=-512*ones(1,d);       % Lower bounds/limits
Ub=512*ones(1,d);        % Upper bounds/limits
%% preallocating
ns=zeros(n,d); %soloutions
Lightn=zeros(1,n); %fitness
x11=zeros(n,1); %initial soloutions for plotting
y11=zeros(n,1);
x22=zeros(n,1);%final soloutions for plotting
y22=zeros(n,1);
e=1; %for counting iterations
mins=0; %for minimums of each iteration
f=zeros(1,1501);
f_tot=zeros(1501,1501); %for plotting
%% initializing
% Generating the initial locations of n fireflies
for i=1:n
   ns(i,:)=Lb+(Ub-Lb).*rand(1,d);         % Randomization
   Lightn(i)=egg_holder(ns(i,:));               % Evaluate objectives
end
%%%%%%%%%%%%%%%%% Start the iterations (main loop) %%%%%%%%%%%%%%%%%%%%%%%
fbest=0; %best fitness for exit condition
for i=1:n %initial swarm
    x11(i,1)=ns(i,1);
    y11(i,1)=ns(i,2);
end
%% optimization
tic
while fbest+959.6407>0.01 %exit condition
 alpha=alpha*theta;     % Reduce alpha by a factor theta
 scale=abs(Ub-Lb);      % Scale of the optimization problem
 %% reset the whole initial swarm and alpha factor
 if alpha<1e-4 %To avoid getting stuck in the loop
     alpha=0.9;
     for i=1:n
       ns(i,:)=Lb+(Ub-Lb).*rand(1,d);         % Randomization
       Lightn(i)=egg_holder(ns(i,:));               % Evaluate objectives
     end
 end
% Two loops over all the n fireflies
for i=1:n
    for j=1:n
      % Evaluate the objective values of current solutions
      Lightn(i)=egg_holder(ns(i,:));           % Call the objective
      % Update moves
      if Lightn(i)>=Lightn(j)          % Brighter/more attractive
         r=sqrt(sum((ns(i,:)-ns(j,:)).^2));
         beta=beta0*exp(-gamma*r.^2);    % Attractiveness
         steps=alpha.*(rand(1,d)-0.5).*scale;
      % The FA equation for updating position vectors
         ns(i,:)=ns(i,:)+beta*(ns(j,:)-ns(i,:))+steps;

      end
   end % end for j
end % end for i
% Check if the new solutions/locations are within limits/bounds
         % Make sure that new fireflies are within the bounds/limits
for i=1:n
  nsol_tmp=ns(i,:);
  % Apply the lower bound
  I=nsol_tmp<Lb;  nsol_tmp(I)=Lb(I);
  % Apply the upper bounds
  J=nsol_tmp>Ub;  nsol_tmp(J)=Ub(J);
  % Update this new move
  ns(i,:)=nsol_tmp;
  Lightn(i)=egg_holder(ns(i,:));
end

%% Rank fireflies by their light intensity/objectives
[Lightn,Index]=sort(Lightn);
nsol_tmp=ns;
for i=1:n
 ns(i,:)=nsol_tmp(Index(i),:);
end
%% Find the current best solution and display outputs
fbest=Lightn(1); nbest=ns(1,:);
e=e+1;
mins=[mins fbest]; %#ok
end % End of the main FA loop (up to tMax) 
toc
%% results
%printing final results
disp(['best fitness =  ' num2str(fbest)]);
disp(' ');
disp(['best solution =  ' num2str(nbest)]);
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
z11=1000*ones(n,1);
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
for i=1:n
x22(i,1)=ns(i,1);
y22(i,1)=ns(i,2);
end
z22=1000*ones(n,1);
scatter3(x22,y22,z22,'filled')
xlabel('solution')
title('final condition')
hold off
%best answer in every iteration plotting
figure(2)
t=1:e;
plot(t,(mins),'-');
xlabel('iterations')
ylabel('optimum')
grid