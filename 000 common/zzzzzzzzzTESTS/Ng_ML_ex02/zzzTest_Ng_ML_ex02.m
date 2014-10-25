%% Machine Learning Online Class - Exercise 2: Logistic Regression
%
%  Instructions
%  ------------
% 
%  This file contains code that helps you get started on the second part
%  of the exercise which covers regularization with logistic regression.
%
%  You will need to complete the following functions in this exericse:
%
%     sigmoid.m
%     costFunction.m
%     predict.m
%     costFunctionReg.m
%
%  For this exercise, you will not need to change any code in this file,
%  or any other files other than those mentioned above.
%

%% Initialization
close all;

%% Load Data
%  The first two columns contains the X values and the third column
%  contains the label (y).

data = load('ex2data2.txt');
X = data(:, [1, 2]);
y = data(:, 3);
m = length(y);
%plotData(X, y);

% Put some labels 
%hold on;

% Labels and Legend
%xlabel('Microchip Test 1')
%ylabel('Microchip Test 2')

% Specified in plot order
%legend('y = 1', 'y = 0')
%hold off;


%% =========== Part 1: Regularized Logistic Regression ============
%  In this part, you are given a dataset with data points that are not
%  linearly separable. However, you would still like to use logistic 
%  regression to classify the data points. 
%
%  To do so, you introduce more features to use -- in particular, you add
%  polynomial features to our data matrix (similar to polynomial
%  regression).
%

% Add Polynomial Features

% Note that mapFeature also adds a column of ones for us, so the intercept
% term is handled
X = mapFeature(X(:,1), X(:,2));
 %fprintf('\nProgram paused. Press enter to continue.\n');
 %pause;


% Initialize fitting parameters
%initial_theta = zeros(size(X, 2), 1);

% Set regularization parameter lambda to 1
%lambda = 1;

% Compute and display initial cost and gradient for regularized logistic
% regression
%[cost, grad] = costFunctionReg(initial_theta, X, y, lambda);

%fprintf('Cost at initial theta (zeros): %f\n', cost);

%fprintf('\nProgram paused. Press enter to continue.\n');
%pause;

%% ============= Part 2: Regularization and Accuracies =============
%  Optional Exercise:
%  In this part, you will get to try different values of lambda and 
%  see how regularization affects the decision coundart
%
%  Try the following values of lambda (0, 1, 10, 100).
%
%  How does the decision boundary change when you vary lambda? How does
%  the training set accuracy vary?
%

% Initialize fitting parameters
initial_theta = zeros(size(X, 2), 1);

% Set regularization parameter lambda to 1 (you should vary this)
lambda = 3e-2;
maxNumIters = 8e3;
% Set Options
options = optimset('GradObj', 'on', 'MaxIter', maxNumIters);

% Optimize
[theta, J, exit_flag] = ...
	fminunc(@(t)(costFunctionReg(t, X, y, lambda)), initial_theta, options);
%theta
%size(theta)
%J
c = costFunction(theta, X, y);
% Plot Boundary
plotDecisionBoundary(theta, X, y);
hold on;
title(sprintf('lambda = %g', lambda))

% Labels and Legend
xlabel('Microchip Test 1')
ylabel('Microchip Test 2')

legend('y = 1', 'y = 0', 'Decision boundary')
hold off;

% Compute accuracy on our training set
p = predict(theta, X);

fprintf('Train Accuracy: %f\n', mean(double(p == y)) * 100);






% Initialize fitting parameters
initial_theta = zeros(size(X, 2), 1);

X = X(:, 2:end);
% NEURAL NET
% ----------
ffNN = class_ffNN...
      (inputDimSizes_perCase_vec = 27, ...
      addlLayersNumsNodes_vec = [], ...
      transformFuncs_list = {'logistic'}, ...
      displayOverview = false, ...
      initWeights_rand = false);

ffNN = train_conjGrad...
   (ffNN_init = ffNN, ...
   dataArgs_list = {X y 1.0}, ...
   targetOutputs_areClassIndcsColVecs = false, ...
   numIters_perEpoch = 6, ...
   trainNumEpochs = 10, ...
   trainBatchSize = false, ...
   trainRandShuff = false, ...
   trainCostApproxChunk_numBatches = 1, ...
   validCostCalcInterval_numChunks = 1, ...
   weightRegulArgs_list = {{'L2'} [lambda / m]}, ...
   connectProbs = [1.0], ...
   bestStop = false);
      
%ffNN = train_rmsProp...
%      (ffNN_init = ffNN, ...
%      dataArgs_list = {X y 1.0}, ...
%      targetOutputs_areClassIndcsColVecs = false, ...
%      trainNumEpochs = 480, ...
%      trainBatchSize = false, ...   
%      trainRandShuff = false, ...
%      trainCostApproxChunk_numBatches = 1, ...
%      validCostCalcInterval_numChunks = 1, ...
%      stepRate_init = 0.01, ...
%      decayRate = 0.9, ...
%      momentumRate_init = 0.9, ...
%      nesterovAccGrad = true, ...
%      weightRegulArgs_list = {{'L2'} [lambda / m]}, ...
%      connectProbs = [1.0], ...
%      bestStop = false);

w = ffNN.weights;

[~, J_ffNN_noRegul, J_ffNN] = fProp_bProp(ffNN, X, y, false, ...
   {{'L2'} [lambda / m]}, false);
theta_ffNN = w{1};
%size(theta_ffNN)
plotDecisionBoundary(theta_ffNN, [ones(118, 1) X], y);

pred = predict(ffNN, X);

[p pred]
equalTest(p, pred)
[c J_ffNN_noRegul]
relDiff = distRel(c, J_ffNN_noRegul)
[J J_ffNN]
relDiff = distRel(J, J_ffNN)
[theta theta_ffNN]
relDiff = distRel(theta, theta_ffNN)

