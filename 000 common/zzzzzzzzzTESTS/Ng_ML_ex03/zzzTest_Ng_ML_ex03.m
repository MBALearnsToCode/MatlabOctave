%% Machine Learning Online Class - Exercise 3 | Part 2: Neural Networks

%  Instructions
%  ------------
% 
%  This file contains code that helps you get started on the
%  linear exercise. You will need to complete the following functions 
%  in this exericse:
%
%     lrCostFunction.m (logistic regression cost function)
%     oneVsAll.m
%     predictOneVsAll.m
%     predict.m
%
%  For this exercise, you will not need to change any code in this file,
%  or any other files other than those mentioned above.
%

%% Initialization
%clear all; close all; clc

%% Setup the parameters you will use for this exercise
input_layer_size  = 400;  % 20x20 Input Images of Digits
hidden_layer_size = 25;   % 25 hidden units
num_labels = 10;          % 10 labels, from 1 to 10   
                          % (note that we have mapped "0" to label 10)

%% =========== Part 1: Loading and Visualizing Data =============
%  We start the exercise by first loading and visualizing the dataset. 
%  You will be working with a dataset that contains handwritten digits.
%

% Load Training Data
fprintf('Loading and Visualizing Data ...\n')

load('ex3data1.mat');
m = size(X, 1);


% Randomly select 100 data points to display
sel = randperm(size(X, 1));
sel = sel(1:80);
testImgs = permute(reshape(X(sel, :), [80 20 20]), [2 3 1]);
plot2D_grayImages(testImgs);

%% ================ Part 2: Loading Pameters ================
% In this part of the exercise, we load some pre-initialized 
% neural network parameters.

fprintf('\nLoading Saved Neural Network Parameters ...\n')

% Load the weights into variables Theta1 and Theta2
load('ex3weights.mat');

%% ================= Part 3: Implement Predict =================
%  After training the neural network, we would like to use it to predict
%  the labels. You will now implement the "predict" function to use the
%  neural network to predict the labels of the training set. This lets
%  you compute the training set accuracy.

[pred activ] = predict(Theta1, Theta2, X);

fprintf('\nTraining Set Accuracy: %f\n', mean(double(pred == y)) * 100);

%%% NEURAL NET
%%% ----------
ffNN = class_ffNN(400, [25 10], {'logistic' 'logistic'}, ...
   true, false);
ffNN.weights = {Theta1' Theta2'};

[~, ~, ~, activ_ffNN] = fProp_bProp(ffNN, X);
%[activ(1:10, 1:3) activ_ffNN(1:10, 1:3)]
activTest = equalTest(activ, activ_ffNN)
[~, pred_ffNN] = max(activ_ffNN, [], 2);
predTest = equalTest(pred, pred_ffNN)