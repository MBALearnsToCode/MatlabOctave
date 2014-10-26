%% Machine Learning Online Class
%  Exercise 6 | Support Vector Machines
%
%  Instructions
%  ------------
% 
%  This file contains code that helps you get started on the
%  exercise. You will need to complete the following functions:
%
%     gaussianKernel.m
%     dataset3Params.m
%     processEmail.m
%     emailFeatures.m
%
%  For this exercise, you will not need to change any code in this file,
%  or any other files other than those mentioned above.
%

%% Initialization
close all

%% =============== Part 1: Loading and Visualizing Data ================
%  We start the exercise by first loading and visualizing the dataset. 
%  The following code will load the dataset into your environment and plot
%  the data.
%

fprintf('Loading and Visualizing Data ...\n')

% Load from ex6data1: 
% You will have X, y in your environment
load('ex6data1.mat');

% Plot training data
plotData(X, y);

fprintf('Program paused. Press enter to continue.\n');
%pause;

%% ==================== Part 2: Training Linear SVM ====================
%  The following code will train a linear SVM on the dataset and plot the
%  decision boundary learned.
%

% Load from ex6data1: 
% You will have X, y in your environment
load('ex6data1.mat');

fprintf('\nTraining Linear SVM ...\n')

% You should try to change the C value below and see how the decision
% boundary varies (e.g., try C = 1000)
C = 10;
model = svmTrain(X, y, C, @linearKernel, 1e-3, 300);
visualizeBoundaryLinear(X, y, model);

modelT = svm_train(X, y, C);

[length(model.y) length(modelT.targetOutput_supVecs)]
[model.b modelT.bias]
[distAbs(model.alphas) distAbs(modelT.alphas_supVecs)]
[model.w modelT.weights]

equalTest(length(model.y), ...
   length(modelT.targetOutput_supVecs), 1, 'abs')
fprintf('\n')
equalTest(model.b, modelT.bias, 1e-3)
fprintf('\n')
[eqTest relD avgAbsD maxAbsD] = ...
   equalTest(distAbs(model.alphas), ...
   distAbs(modelT.alphas_supVecs), 1e-3)
fprintf('\n')
[eqTest relD avgAbsD maxAbsD] = ...
   equalTest(model.w, modelT.weights, 1e-3)
fprintf('\n')

fprintf('LINEAR SVM TEST done. Press enter to continue.\n');
pause;

%% =============== Part 3: Implementing Gaussian Kernel ===============
%  You will now implement the Gaussian kernel to use
%  with the SVM. You should complete the code in gaussianKernel.m
%
fprintf('\nEvaluating the Gaussian Kernel ...\n')

x1 = [1 2 1]; x2 = [0 4 -1]; sigma = 2;
sim = gaussianKernel(x1, x2, sigma);

fprintf(['Gaussian Kernel between x1 = [1; 2; 1], x2 = [0; 4; -1], sigma = 0.5 :' ...
         '\n\t%f\n(this value should be about 0.324652)\n'], sim);

fprintf('Program paused. Press enter to continue.\n');
%pause;

%% =============== Part 4: Visualizing Dataset 2 ================
%  The following code will load the next dataset into your environment and 
%  plot the data. 
%

fprintf('Loading and Visualizing Data ...\n')

% Load from ex6data2: 
% You will have X, y in your environment
load('ex6data2.mat');

% Plot training data
plotData(X, y);

fprintf('Program paused. Press enter to continue.\n');
%pause;

%% ========== Part 5: Training SVM with RBF Kernel (Dataset 2) ==========
%  After you have implemented the kernel, we can now use it to train the 
%  SVM classifier.
% 
fprintf('\nTraining SVM with RBF Kernel (this may take 1 to 2 minutes) ...\n');

% Load from ex6data2: 
% You will have X, y in your environment
load('ex6data2.mat');

% SVM Parameters
C = 1; sigma = 0.1;

% We set the tolerance and max_passes lower here so that the code will run
% faster. However, in practice, you will want to run the training to
% convergence.
model= svmTrain(X, y, C, @(x1, x2) gaussianKernel(x1, x2, sigma), ...
   1e-3, 30);
visualizeBoundary(X, y, model);
modelT = svm_train(X, y, C, ...
   @(rM1, rM2) gaussKernMat_rowMat(rM1, rM2, sigma), 9);

[length(model.y) length(modelT.targetOutput_supVecs)]
[model.b modelT.bias]
[distAbs(model.alphas) distAbs(modelT.alphas_supVecs)]

equalTest(length(model.y), ...
   length(modelT.targetOutput_supVecs), 6, 'abs')
fprintf('\n')
equalTest(model.b, modelT.bias, 1e-1)
fprintf('\n')
[eqTest relD avgAbsD maxAbsD] = ...
   equalTest(distAbs(model.alphas), ...
   distAbs(modelT.alphas_supVecs), 1e-2)