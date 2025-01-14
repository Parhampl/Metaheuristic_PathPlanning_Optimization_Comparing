% Run the BFO_benchmark.m script 5 times
diary('BenchMark_output.txt');
for z = 1:5
    disp(['Running iteration: ', num2str(z)]);
    EFO_BenchMark;  % This calls the BFO_benchmark.m script
    disp(' ');
    disp(' ');
    disp(' ');
    disp(' ');
end
% Stop recording
diary off;
