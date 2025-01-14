% Run the BFO_benchmark.m script 5 times
diary('BnechMark_output.txt');
for z = 1:5
    disp(['Running iteration: ', num2str(z)]);
    TestAutoCalculateFA;  % This calls the BFO_benchmark.m script
    disp(' ');
    disp(' ');
    disp(' ');
    disp(' ');
end
% Stop recording
diary off;
