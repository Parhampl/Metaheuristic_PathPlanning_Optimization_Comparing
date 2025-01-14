diary('Bfo_Results.txt');

for z = 1:5
    disp(['Running iteration: ', num2str(z)]);
    BFOPahPlanningCorrection;
    gpop.time=elapsed_time;
    filename=strcat(['gpopFile_', num2str(z),'_.mat']);
    save(filename ,'gpop');

    figure1Filename = sprintf('figure_Optimum_Iteration_%d.png', z);
    saveas(figure(1), figure1Filename);

    figure2Filename = sprintf('figure_Initial_VS_Final_%d.png', z);
    saveas(figure(2), figure2Filename);
 
    disp(' ');
    disp(' ');
    disp(' ');
    disp(' ');
end
% Stop recording
diary off;
