function run_optimization_for_all_folders()
    % List of folders containing .mat files with nest data
    folder_names = {'top_right', 'top_left'}; % Add folder names as needed

    % Loop through each folder
    for i = 1:length(folder_names)
        folder_name = folder_names{i};
        disp(['Running optimization for folder: ', folder_name]);
        elapsed_time = run_optimization_with_folder(folder_name);
        disp(['Time taken: ', num2str(elapsed_time), ' seconds']);
        disp(' '); % Add a line break for readability
    end
end

function elapsed_time = run_optimization_with_folder(folder_name)
    % List all .mat files in the specified folder
    mat_files = dir(fullfile(folder_name, '*.mat'));

    % Loop through each .mat file in the folder
    for j = 1:length(mat_files)
        mat_file = mat_files(j);
        disp(['Running optimization with file: ', mat_file.name]);
        
        % Load nest data from the .mat file
        nest_data = load(fullfile(folder_name, mat_file.name));
        nest = double(nest_data.x);
        
        % Run the optimization code
        % You need to replace 'testcukoo' with the actual function name from testcukoo.m
        tic;
        Cuckoo_Test(nest); % Call the testcukoo function with the loaded nest data
        elapsed_time = toc;
        
        % Display the time taken for optimization
        disp(['Time taken: ', num2str(elapsed_time), ' seconds']);
        disp(' '); % Add a line break for readability
    end
end
