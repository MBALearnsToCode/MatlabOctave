% This script demonstrates the following:
% 1. Logistic Regression to classify normal vs. abnormal items
% 2. Use of high-dimensional polynomial mapping to overcome
% linear-inseparability in 2 dimensions
% 3. Use of weight regularization in reducing overfitting

function ffNN = ffNN_qc_logReg(weightPenaltyTerm = 0, ...
   numEpochs = 100, numIters_perEpoch = 30, polyDeg = 9);

   % Close existing plots
   close all;
 
   % Load data
   data = load('qualityControl.txt');
   X = data(:, [1 2]);
   y = data(:, 3);
   
   % Plot binary classification data
   plot2D_binClasses(y, X);
   
   % Map 2D input features to higher-degree polynomials
   % for modelling flexibility   
   X_poly = polyUpToDeg(X, polyDeg);
   numPolyTerms = columns(X_poly) 
   
   % Set up simple Forward-Feeding Neural Network (FFNN)
   % to perform logistic regression
   ffNN = class_ffNN...
      (inputDimSizes_perCase_vec = numPolyTerms, ...
      addlLayersNumsNodes_vec = [], ...
      transformFuncs_list = {'logistic'}, ...
      displayOverview = false, ...
      initWeights_rand = false);
   weights = ffNN.weights;
   sum(weights{1})
   % Train FFNN with CONJUGATE GRADIENT method,
   % which is a fast FULL-BATCH algorithm suitable
   % for this small dataset
   ffNN = train_conjGrad...
      (ffNN_init = ffNN, ...
      dataArgs_list = {X_poly y 1.0}, ...
      targetOutputs_areClassIndcsColVecs = false, ...
      numIters_perBatch = numIters_perEpoch, ...
      trainNumEpochs = numEpochs, ...
      trainBatchSize = false, ...   
      trainRandShuff = false, ...
      trainCostApproxChunk_numBatches = 1, ...
      validCostCalcInterval_numChunks = 1, ...
      weightRegulArgs_list = {{'L2'} [weightPenaltyTerm]}, ...
      connectProbs = [1.0], ...
      bestStop = true);
   % Retrieve trained weights   
   weights = ffNN.weights;
   w = weights{1};
   
   % Plot decision boundary
   func_decision_vsZero = @(X) ...
      addBiasElems(polyUpToDeg(X, polyDeg)) * w;
   plot2D_decisionBoundary(y, X, func_decision_vsZero);

   % Compute predictive accuracy
   predictions = predict(ffNN, X_poly);
   fprintf('Classification Accuracy on training dataset = %f\n', ...
      100 * mean(double(predictions == y)));
   fprintf('\nComprehensive Evaluation of Classification performance:\n');
   evalClassif(predictions, y)

endfunction