function ffNN_housePrices_multiLinReg...
   (weightRegulParam = 0.03)
   
   % load House Prices data
   data = load('housePrices.txt');   
   x = houseAreas_sqft = data(:, 1);
   y = housePrices_000 = data(:, 3) / (10 ^ 3);

   % split data into:
   % 1. Training set (which machine will see and adjust
   % itself to);
   % 2. Validation set (which the machine will also see
   % to cross-check its own out-of-sample performance
   % during Training); and
   % 3. Test set (which the machine will not see during 
   % Training; this will be used to finally evaluate
   % the machine's performance)
   numCases_train = 20;
   numCases_valid = 12;
   numCases_test = 15;
   indices_train = 1 : numCases_train;
   indices_valid = numCases_train + (1 : numCases_valid);
   indices_test = numCases_train + numCases_valid ...
      + (1 : numCases_test);
      
   [x_train x_sortedIndices_train] = ...
      sort(x(indices_train));
   y_train = ...
      y(indices_train)(x_sortedIndices_train);
   
   [x_valid x_sortedIndices_valid] = ...
      sort(x(indices_valid));
   y_valid = ...
      y(indices_valid)(x_sortedIndices_valid);
      
   [x_test x_sortedIndices_test] = ...
      sort(x(indices_test));
   y_test = ...
      y(indices_test)(x_sortedIndices_test);   
   
   % construct a small-interval x series
   % for fitted-curve plotting purpose
   x_seriesLength = 100;
   x_smallIntervals = ...
      linspace(min(x), max(x), x_seriesLength)';
      
   fprintf('\n');
   
   % plot Training set
   close all;
   figure; %figure #1  
   plot(x_train, y_train, '.', 'color', 'k', 'markersize', 9);
   title('TRAINING SET');
   fprintf('Training set plotted\n\n');
   pausePressKey;
   fprintf('\n');
   
   % Request highest polynomial degree to which
   % to map input x 
   polyDeg = input('Map Input x to Highest Polynomial Degree: ');
   % Map x into polynomial of higher degree
   % for modelling flexibility
   X_train = polyUpToDeg(x_train, polyDeg);
   X_test = polyUpToDeg(x_test, polyDeg);
   X_smallIntervals = polyUpToDeg(x_smallIntervals, polyDeg);   
   % We normalize X for numerical stability purposes
   [X_train_normalized mu sigma] = ...
      normalizeSubtractDivide(X_train);      
      
   
   
   fprintf('\n\n\n\n');
   % EXPERIMENT 1
   fprintf('EXPERIMENT 1: Linear Regression without Weight Regularization:\n\n');
   % Linear regression coefficients - analytic solution
   weights_analytic_normalized = linRegWeights_analytic...
      (y_train, X_train_normalized);
   % Calculate predicted values
   h_train = ...
      [ones(numCases_train, 1), X_train_normalized] ...
      * weights_analytic_normalized;
   h_test = ...
      [ones(numCases_test, 1), ...
      normalizeSubtractDivide(X_test, mu, sigma)] ...
      * weights_analytic_normalized;
   h_smallIntervals = ...
      [ones(x_seriesLength, 1), ...
      normalizeSubtractDivide(X_smallIntervals, mu, sigma)] ...
      * weights_analytic_normalized;
   
   % Plot fitted values & calculate Costs
   figure(1);
   hold on;   
   plot(x_smallIntervals, h_smallIntervals, 'r');
   cost_train = sum((h_train - y_train) .^ 2) ...
      / (2 * numCases_train);
   fprintf('Training set RMSE = %.3g\n\n', ...
      sqrt(2 * cost_train));
   pausePressKey;
   figure(2);
   hold on;
   plot(x_test, y_test, '.', 'color', 'b', 'markersize', 9);
   title('TEST SET');   
   plot(x_smallIntervals, h_smallIntervals, 'r');
   cost_test = sum((h_test - y_test) .^ 2) ...
      / (2 * numCases_test);
   fprintf('\nTest set RMSE = %.3g\n\n', sqrt(2 * cost_test));
   
   
   
   fprintf('\n\n\n');
   % We will now REGULARIZE the weights (i.e. penalize
   % the sum of squared weights) to reduce overfitting
   experiment2 = ...
      input(sprintf('EXPERIMENT 2: Linear Regression with Weight Regularization Term = %.3g: PROCEED? (0 / 1): ', ...
      weightRegulParam));
   
   if (experiment2)
   
      weights_analytic_normalized = linRegWeights_analytic...
         (y_train, X_train_normalized, weightRegulParam);
         
      % Calculate & plot predicted values
      h_train = ...
         [ones(numCases_train, 1), X_train_normalized] ...
         * weights_analytic_normalized;
      h_test = ...
         [ones(numCases_test, 1), ...
         normalizeSubtractDivide(X_test, mu, sigma)] ...
         * weights_analytic_normalized;
      h_smallIntervals = ...
         [ones(x_seriesLength, 1), ...
         normalizeSubtractDivide(X_smallIntervals, mu, sigma)] ...
         * weights_analytic_normalized;
         
      % Plot fitted values & calculate Costs      
      figure(1);
      hold on;
      plot(x_smallIntervals, h_smallIntervals, ...
         'g', 'LineWidth', 3);
      cost_train = sum((h_train - y_train) .^ 2) ...
         / (2 * numCases_train);
      fprintf('\nTraining set RMSE = %.3g\n\n', ...
         sqrt(2 * cost_train));
      figure(2);
      hold on;
      plot(x_smallIntervals, h_smallIntervals, ...
         'g', 'LineWidth', 3);
      cost_test = sum((h_test - y_test) .^ 2) ...
         / (2 * numCases_test);
      fprintf('Test set RMSE = %.3g\n\n', ...
         sqrt(2 * cost_test));
      
      pausePressKey;
      % ***************************************************
      % We will now re-run Experiment 2 by a Neural Network
      % learning model
      fprintf('\n\n\nRe-running using Neural Network learning:\n');
      
      % Create simple neural net with linear function and 
      % 1 top-layer node
      ffNN = class_ffNN...
         (inputDimSizes_perCase___ = polyDeg, ...
         addlLayersNumsNodes___ = [1], ...
         transformFuncs___ = {'linear'}, ...
         displayOverview___ = false, ...
         initWeights___ = false);
      % Set normalizing parameters
      ffNN.normalizeSubtract = mu;
      ffNN.normalizeDivide = sigma;
      
      ffNN = train_conjGrad...
         (ffNN_init___ = ffNN, ...
         dataArgs___ = {X_train y_train 1.0}, ...
         targetOutputs_areClassIndcsColVecs___ = false, ...
         numIters_perEpoch___ = 3000, ...
         trainNumEpochs___ = 1, ...
         trainBatchSize___ = false, ...   
         trainRandShuff___ = false, ...
         trainCostApproxChunk_numBatches___ = 1, ...
         validCostCalcInterval_numChunks___ = 1, ...
         weightRegulArgs___ = {{'L2'} [weightRegulParam]}, ...
         connectProbs___ = [1.0], ...
         bestStop___ = true);
      
      h_train = predict(ffNN, X_train);
      cost_train = sum((h_train - y_train) .^ 2) ...
         / (2 * numCases_train);
      fprintf('\nTraining set RMSE = %.3g\n\n', ...
         sqrt(2 * cost_train));
      h_test = predict(ffNN, X_test);
      cost_test = sum((h_test - y_test) .^ 2) ...
         / (2 * numCases_test);
      fprintf('Test set RMSE = %.3g\n\n', ...
         sqrt(2 * cost_test));
      
   endif
   
   
   
   

   

   
  % relativeDiff = distRel(weights_ffNN, coeffs_analyticNormalized)
   
  % testArea = 1000;
  % testNumBedrooms = 2;
  % fprintf('\nPredicted Price of House with Area = %i, No. of Bedrooms = %i:\n', ...
  %    testArea, testNumBedrooms);
  % fprintf('   from Analytic Solution: %g\n', ...
  %    [1 testArea testNumBedrooms] * coeffs_analytic);
  % fprintf('   from ffNN Solution: %g\n', ...
  %    predict(ffNN, [testArea testNumBedrooms]));
   
  % fprintf('\n');   
   
endfunction