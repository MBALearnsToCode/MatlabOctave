% Initialization
clear ; close all; clc

%% Setup the parameters you will use for this exercise
input_layer_size  = 400;  % 20x20 Input Images of Digits
hidden_layer_size = 25;   % 25 hidden units
num_labels = 10;          % 10 labels, from 1 to 10   
                          % (note that we have mapped "0" to label 10)


% LOAD DATA
% ---------
load('ex4data1.mat');
m = size(X, 1);


load('ex4weights.mat');

% Unroll parameters 
nn_params = [Theta1(:) ; Theta2(:)];



%% ================ Part 3: Compute Cost (Feedforward) ================
%  To the neural network, you should first start by implementing the
%  feedforward part of the neural network that returns the cost only. You
%  should complete the code in nnCostFunction.m to return cost. After
%  implementing the feedforward to compute the cost, you can verify that
%  your implementation is correct by verifying that you get the same cost
%  as us for the fixed debugging parameters.
%
%  We suggest implementing the feedforward cost *without* regularization
%  first so that it will be easier for you to debug. Later, in part 4, you
%  will get to implement the regularized cost.
%
fprintf('\nFeedforward Using Neural Network ...\n')

% Weight regularization parameter (we set this to 0 here).
lambda = 0;

J = nnCostFunction(nn_params, input_layer_size, hidden_layer_size, ...
                   num_labels, X, y, lambda);

fprintf(['Cost at parameters (loaded from ex4weights): %f '...
         '\n(this value should be about 0.287629)\n'], J);
Y = convertClassifColVecToRowMat(y);
%%% TEST NEURAL NET
%%% ---------------
ffNN = ffNN_new(400, [25 10], {'logistic' 'logistic'}, ...
   true, false);
loadedParams = {Theta1' Theta2'};
loadedInputParams_vec = ...
   convertArrsToColVec([X loadedParams]);
cost_ffNN = ffNN_costWRegul_n_inputGrad_n_paramGrads...
   (loadedInputParams_vec, ffNN, Y, lambda)
cost_ffNN - J
fprintf('\nCost Checked. Press enter to continue.\n');
%pausePressKey;

%% =============== Part 4: Implement Regularization ===============
%  Once your cost function implementation is correct, you should now
%  continue to implement the regularization with the cost.
%

fprintf('\nChecking Cost Function (w/ Regularization) ... \n')

% Weight regularization parameter (we set this to 1 here).
lambda = 1;

J = nnCostFunction(nn_params, input_layer_size, hidden_layer_size, ...
                   num_labels, X, y, lambda);

fprintf(['Cost at parameters (loaded from ex4weights): %f '...
         '\n(this value should be about 0.383770)\n'], J);

fprintf('Program paused. Press enter to continue.\n');
%pause;


%% ================ Part 5: Sigmoid Gradient  ================
%  Before you start implementing the neural network, you will first
%  implement the gradient for the sigmoid function. You should complete the
%  code in the sigmoidGradient.m file.
%

fprintf('\nEvaluating sigmoid gradient...\n')

g = sigmoidGradient([1 -0.5 0 0.5 1]);
fprintf('Sigmoid gradient evaluated at [1 -0.5 0 0.5 1]:\n  ');
fprintf('%f ', g);
fprintf('\n\n');

fprintf('Program paused. Press enter to continue.\n');
%pause;


%% ================ Part 6: Initializing Pameters ================
%  In this part of the exercise, you will be starting to implment a two
%  layer neural network that classifies digits. You will start by
%  implementing a function to initialize the weights of the neural network
%  (randInitializeWeights.m)

fprintf('\nInitializing Neural Network Parameters ...\n')

initial_Theta1 =  randInitializeWeights(input_layer_size, hidden_layer_size);
size(initial_Theta1)
initial_Theta2 =  randInitializeWeights(hidden_layer_size, num_labels);
size(initial_Theta2)

% Unroll parameters
initial_nn_params = [initial_Theta1(:) ; initial_Theta2(:)];


%% =============== Part 7: Implement Backpropagation ===============
%  Once your cost matches up with ours, you should proceed to implement the
%  backpropagation algorithm for the neural network. You should add to the
%  code you've written in nnCostFunction.m to return the partial
%  derivatives of the parameters.
%
fprintf('\nChecking Backpropagation... \n');

%  Check gradients by running checkNNGradients
checkNNGradients;

fprintf('\nProgram paused. Press enter to continue.\n');
%pause;


%% =============== Part 8: Implement Regularization ===============
%  Once your backpropagation implementation is correct, you should now
%  continue to implement the regularization with the cost and gradient.
%

fprintf('\nChecking Backpropagation (w/ Regularization) ... \n')

%  Check gradients by running checkNNGradients
lambda = 3;
checkNNGradients(lambda);

% Also output the costFunction debugging values
debug_J  = nnCostFunction(nn_params, input_layer_size, ...
                          hidden_layer_size, num_labels, X, y, lambda);

fprintf(['\n\nCost at (fixed) debugging parameters (w/ lambda = 10): %f ' ...
         '\n(this value should be about 0.576051)\n\n'], debug_J);

fprintf('Program paused. Press enter to continue.\n');
%pause;


%% =================== Part 8: Training NN ===================
%  You have now implemented all the code necessary to train a neural 
%  network. To train your neural network, we will now use "fmincg", which
%  is a function which works similarly to "fminunc". Recall that these
%  advanced optimizers are able to train our cost functions efficiently as
%  long as we provide them with the gradient computations.
%
fprintf('\nTraining Neural Network... \n')

%  After you have completed the assignment, change the MaxIter to a larger
%  value to see how more training helps.


maxNumIters = 48;

options = optimset('GradObj', 'on', 'MaxIter', maxNumIters);

%  You should also try different values of lambda
lambda = 3;

% Create "short hand" for the cost function to be minimized
costFunction = @(p) nnCostFunction(p, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, X, y, lambda);

[costInit gradInit] = costFunction(initial_nn_params);
costInit

% Now, costFunction is a function that takes in only one argument (the
% neural network parameters)
[nn_params, cost] = fmincg(costFunction, initial_nn_params, options);

%[nn_params_flip, cost_flip] = fmincg(costFunction_flip, ...
%    fliplr(initial_nn_params), options);

% Obtain Theta1 and Theta2 back from nn_params
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

loadedParams = {Theta1' Theta2'};
loadedInputParams_vec = ...
   convertArrsToColVec([X loadedParams]);
cost_ffNN = ffNN_costWRegul_n_inputGrad_n_paramGrads...
   (loadedInputParams_vec, ffNN, Y, lambda)
cost_ffNN - cost(end)


fprintf('DONE 1st TRAINING. Press enter to continue.\n');
%pause;


%% ================= Part 10: Implement Predict =================
%  After training the neural network, we would like to use it to predict
%  the labels. You will now implement the "predict" function to use the
%  neural network to predict the labels of the training set. This lets
%  you compute the training set accuracy.

[pred activ] = predict(Theta1, Theta2, X);

fprintf('\nTraining Set Accuracy: %f\n', mean(double(pred == y)) * 100);



initParams = ...
   {initial_Theta1' initial_Theta2'};

initInputParams_colVec = convertArrsToColVec...
      ([X initParams]);

[costInit_ffNN gradInit_ffNN] = ...
   ffNN_costWRegul_n_inputGrad_n_paramGrads...
   (initInputParams_colVec, ffNN, Y, lambda);
costInit_ffNN
costInit_ffNN - costInit






[ffNN cost_ffNN] = ffNN_train...
   (X, ffNN, Y, maxNumIters, ...
   lambda, initParams);

pred_ffNN = ffNN_predict(X, ffNN);
fprintf('\nTraining Set Accuracy: %f\n', mean(double(pred == y)) * 100);
fprintf('\nTraining Set Accuracy (ffNN): %f\n', mean(double(pred_ffNN == y)) * 100);

[eqTest relD avgAbsD maxAbsD] = ...
   equalTest(Theta1', ffNN.params{2}, 1e-3)
[eqTest relD avgAbsD maxAbsD] = ...
   equalTest(Theta2', ffNN.params{3}, 1e-3)

activ_ffNN = ffNN.hypoOutput;
[eqTest relD avgAbsD maxAbsD] = ...
   equalTest(activ, activ_ffNN, 1e-3)

fprintf('\nMatching Percent: %f\n', ...
   100 * sum(pred_ffNN == pred) / length(pred));