clear;
clc;
clear all;
%%
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
        f(i)=-x1(j)*sin(sqrt(abs(x1(j)-x2(i)-47))) - (x2(i)+47)*...
             sin(sqrt(abs(0.5*x1(j)+x2(i)+47)));
    end
    f_tot(j,:)=f;
end

% 1-dimensional plot is not applicable with this benchmark function
nexttile % contour plotting
mesh(x1,x2,f_tot); view(0,90); colorbar; set(gca,'FontSize',12);
xlabel('x_2','FontName','Times','FontSize',20,'FontAngle','italic');
ylabel('x_1','FontName','Times','FontSize',20,'FontAngle','italic');
zlabel('f(X)','FontName','Times','FontSize',20,'FontAngle','italic');
title('X-Y Plane View','FontName','Times','FontSize',24,'FontWeight','bold');
