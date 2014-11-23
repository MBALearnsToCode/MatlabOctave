function f = ffNN_bicepCurls_evaluateClassifier...
   (loadFileName = 'ffNN_bicepCurls.mat');
      
   % load data
   fprintf('\nLoading Bicep Curl Quality Dataset...');
   [X y] = load_bicepCurlQuality;
   r = load('bicepCurlQuality_randperm.mat').randperm_39242;
   X_test = X(r(1 : 20000), :);
   y_test = y(r(1 : 20000));
   fprintf(' done!\n');   
   
   ffNN = ffNN_loadFile(loadFileName);
   p_test = predict(ffNN, X_test);
   f = sum(p_test == y_test);
   fprintf('%i / 20000 cases (%.3g%%) correct\n', f, 100 * f / 20000);
   
endfunction