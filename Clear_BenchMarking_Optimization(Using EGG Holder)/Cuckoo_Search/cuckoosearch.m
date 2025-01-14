clear;
clc;
close all;
%% parameters
% Number of nests (or different solutions)
n=60;
% Discovery rate of alien eggs/solutions
pa=0.25;
% Lower bounds
nd=2; 
Lb=-512*ones(1,nd);
% Upper boundsfmin
Ub=512*ones(1,nd);
% Random initial solutions
%% preallocating
x11=zeros(n,1);
y11=zeros(n,1);
x22=zeros(n,1);
y22=zeros(n,1);
mins1=0; %minimum of each iteration
f=zeros(1,1501);
f_tot=zeros(1501,1501); %for plotting
e=1; %to count the number of iterations
nest=zeros(n,nd);
%% Change this if you want to get better results
% Tolerance
Tol=1.0e-2;
%% initialization

for i=1:n
nest(i,:)=Lb+(Ub-Lb).*rand(size(Lb));
end
% Get the current best
fitness=10^10*ones(n,1); %preallocating and making sure the initial state will be changed
[fmin,bestnest,nest,fitness]=get_best_nest(nest,nest,fitness);
for i=1:n
    x11(i,1)=nest(i,1);
    y11(i,1)=nest(i,2);
end %for plotting the initial nests
%% optimization
tic;
while (fmin+959.6407>Tol) %exit condition
    % Generate new solutions (but keep the current best)
     new_nest=get_cuckoos(nest,bestnest,Lb,Ub);   
     [~,~,nest,fitness]=get_best_nest(nest,new_nest,fitness);
    % Discovery and randomization
      new_nest=empty_nests(nest,Lb,Ub,pa) ;
    
    % Evaluate this set of solutions
      [fnew,best,nest,fitness]=get_best_nest(nest,new_nest,fitness);
    % Find the best objective so far  
    if fnew<fmin
        fmin=fnew;
        bestnest=best;
    end
    mins1=[mins1 fmin];
    e=e+1;
end %% End of iterations
toc;

%% Post-optimization processing
[sorts,Is]=sort(fitness);
for i=1:n
    sorting(i,1)=nest(Is(i),1);
    sorting(i,2)=nest(Is(i),2);
end
%% Display all the nests
disp(strcat('Best Soloution=',num2str(best)));
disp(strcat('Best Fitness=',num2str(fmin)));
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
x22(i,1)=nest(i,1);
y22(i,1)=nest(i,2);
end
z22=1000*ones(n,1);
scatter3(x22,y22,z22,'filled')
xlabel('solution')
title('final condition')
hold off
%best answer in every iteration plotting
figure(2)
t=1:e;
plot(t,(mins1),'-');
xlabel('iterations')
ylabel('optimum')
grid
