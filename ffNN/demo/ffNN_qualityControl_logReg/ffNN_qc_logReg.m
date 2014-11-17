% This script demonstrates the following:
% 1. Logistic Regression to classify normal vs. abnormal items
% 2. Use of high-dimensional polynomial mapping to overcome
% linear-inseparability in 2 dimensions
% 3. Use of weight regularization in reducing overfitting

function ffNN = ffNN_qc_logReg....
   (weightPenaltyTerm = 0, bestStop = false, ...
   numIters_perEpoch = 1, numEpochs = 100, polyDeg = 9);

   % Close existing plots
   close all;
 
   % Load data
   data = load('qualityControl.txt');
   X = data(:, [1 2]);
   y = data(:, 3);
   
   % split data into Training, Validation & Test sets
   indices_positive = 1 : 58;
   indices_negative = 59 : 118;
   indices_train = logical([mod(indices_positive, 4) > 1, ...
      mod(indices_negative, 4) > 1]);
   indices_valid = logical([mod(indices_positive, 4) == 1, ...
      mod(indices_negative, 4) == 1]);
   indices_test = logical([mod(indices_positive, 4) == 0, ...
      mod(indices_negative, 4) == 0]);
   X_train = X(indices_train, :);
   y_train = y(indices_train);
   X_valid = X(indices_valid, :);
   y_valid = y(indices_valid);
   X_test = X(indices_test, :);
   y_test = y(indices_test);   
   
   % Plot binary classification data   
   plot2D_binClasses(y_train, X_train);
   figure(1);
   title('TRAINING SET');
   plot2D_binClasses(y_valid, X_valid);
   figure(2);
   title('VALIDATION SET');
   plot2D_binClasses(y_test, X_test);
   figure(3);
   title('TEST SET');
   fprintf('\nTraining, Validation & Test sets plotted\n\n');
   pausePressKey;   
   
   % Map 2D input features to higher-degree polynomials
   % for modelling flexibility   
   X_poly = polyUpToDeg(X, polyDeg);
   X_poly_train = polyUpToDeg(X_train, polyDeg);
   X_poly_valid = polyUpToDeg(X_valid, polyDeg);
   X_poly_test = polyUpToDeg(X_test, polyDeg);
   numPolyTerms = columns(X_poly);
   
   % Set up simple Forward-Feeding Neural Network (FFNN)
   % to perform logistic regression
   ffNN = class_ffNN...
      (inputDimSizes_perCase___ = numPolyTerms, ...
      addlLayersNumsNodes___ = [1], ...
      transformFuncs___ = {'logistic'}, ...
      displayOverview___ = false, ...
      initWeights___ = false);

   % Train FFNN with Conjugate Gradient method
   ffNN = train_conjGrad...
      (ffNN_init___ = ffNN, ...
      dataArgs___ = {X_poly_train y_train ...
                     X_poly_valid y_valid ...
                     X_poly_test y_test}, ...
      targetOutput_isClassIndcsColVec___ = false, ...
      classSkewnesses = [1], ...
      numIters_perEpoch___ = numIters_perEpoch, ...
            % large for fast learning, small for slow learning in 1 epoch
      trainNumEpochs___ = numEpochs, ...
            % large for more repeated looks at data, small for fewer repeats
      trainBatchSize = false, ...   
      trainRandShuff = false, ...
      trainCostApproxChunk_numBatches = 1, ...
      validCostCalcInterval_numChunks = 1, ...
      weightRegulArgs___ = {{'L2'} [weightPenaltyTerm]}, ...
            % large WEIGHTPENALTYTERM to severely penalize large weights, small to penalize less severely
      connectProbs___ = [1.0], ...
      bestStop___ = bestStop);
            % TRUE for stopping at best Validation performance
   pausePressKey;
   % Retrieve trained weights   
   weights = ffNN.weights;
   w = weights{1};
   
   % Plot decision boundary
   func_decision_vsZero = @(X) ...
      addBiasElems(polyUpToDeg(X, polyDeg)) * w;
   close all;
   plot2D_decisionBoundary...
      (y_train, X_train, func_decision_vsZero);
   figure(1);
   title('TRAINING SET');
   plot2D_decisionBoundary...
      (y_valid, X_valid, func_decision_vsZero);
   figure(2);
   title('VALIDATION SET');
   plot2D_decisionBoundary...
      (y_test, X_test, func_decision_vsZero);
   figure(3);
   title('TEST SET');
   fprintf('\n');
   
endfunction