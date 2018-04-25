% Constants
TRUE = 1;
FALSE = 0;
APPROACH_1 = 1;
APPROACH_2 = 2;

NumSteps = 5;
runStep = false(NumSteps, 1);

% Select which step(s) to run
runStep(1) = TRUE;
runStep(2) = TRUE;
runStep(3) = TRUE;
runStep(4) = TRUE;
runStep(5) = TRUE;

% Step1: create dataset & input images
if runStep(1)
    create_dataset_images
    create_input_images
end

% Step2: Train dataset using approach 1 & 2
if runStep(2)
    trainer1 % Approach 1
    trainer2 % Approach 2
end

% Step3: Create test images for 0, 1 & 2 extra components
if runStep(3)
    create_results_input(strcat(pwd, '\results_input0'), strcat(pwd, '\results_input_dataset_0_extra_comp'));
    create_results_input(strcat(pwd, '\results_input1'), strcat(pwd, '\results_input_dataset_1_extra_comp'));
    create_results_input(strcat(pwd, '\results_input2'), strcat(pwd, '\results_input_dataset_2_extra_comp'));
end

% Step4: Run Approach 1 on these three datasets
if runStep(4)
    avg_accuracy10 = test_run(APPROACH_1, strcat(pwd, '\results_input0'));
    avg_accuracy11 = test_run(APPROACH_1, strcat(pwd, '\results_input1'));
    avg_accuracy12 = test_run(APPROACH_1, strcat(pwd, '\results_input2'));
    
    fprintf('Approach 1 accuracy:\n');
    fprintf('S.No.\t\t# of extra components\t\tAvg Accuracy\n');
    fprintf('1.)\t\t\t0\t\t\t\t\t\t%.02f%%\n', avg_accuracy10);
    fprintf('2.)\t\t\t1\t\t\t\t\t\t%.02f%%\n', avg_accuracy11);
    fprintf('3.)\t\t\t2\t\t\t\t\t\t%.02f%%\n', avg_accuracy12);
    fprintf('\n');
end

% Step5: Run Approach 5 on these three datasets
if runStep(5)
    avg_accuracy20 = test_run(APPROACH_2, strcat(pwd, '\results_input0'));
    avg_accuracy21 = test_run(APPROACH_2, strcat(pwd, '\results_input1'));
    avg_accuracy22 = test_run(APPROACH_2, strcat(pwd, '\results_input2'));
    
    fprintf('Approach 2 accuracy:\n');
    fprintf('S.No.\t\t# of extra components\t\tAvg Accuracy\n');
    fprintf('1.)\t\t\t0\t\t\t\t\t\t%.02f%%\n', avg_accuracy20);
    fprintf('2.)\t\t\t1\t\t\t\t\t\t%.02f%%\n', avg_accuracy21);
    fprintf('3.)\t\t\t2\t\t\t\t\t\t%.02f%%\n', avg_accuracy22);
    fprintf('\n');
end