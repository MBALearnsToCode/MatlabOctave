function results = ...
   zzzzzzTest_featEmbed_gradChk(numRuns, prec = 1e-6)

   maxNumCases = 3;
   maxSeriesLength = 3;
   maxNumClasses = 3;
   maxNumEmbedFeatures = 3;
   epsilon = 1e1;

   summs = {}; comps = {};
   succs = 0; fails = [];
 
   fprintf('\nRun no.:');

   for (r = 1 : numRuns)
 
      fprintf(' %i', r); 

      m = tests{r}.m = ...
         unidrnd(maxNumCases);
      nI = tests{r}.nI = ...
         unidrnd(maxSeriesLength);
      nC = tests{r}.nC = ...
         unidrnd(maxNumClasses);
      nF = tests{r}.nF = ...
         unidrnd(maxNumEmbedFeatures);

      input_rowMat = tests{r}.input_rowMat = ...
         unidrnd(nC, [m nI]);
      features_rowMat = tests{r}.features_rowMat = ...
         randUnif([nC nF], epsilon);
      calcs = @(input_rowMat, features_rowMat) ...
         convertClassIndexSeries_toNumericalFeatures_rowMat...
         (input_rowMat, features_rowMat);
      output_rowMat = tests{r}.output_rowMat = ...
         calcs(input_rowMat, features_rowMat).val;
      targetOutput_rowMat = ...
         tests{r}.targetOutput_rowMat = ...
         randUnif([m (nI * nF)], epsilon);
      summs{r} = [m nI nC nF];

      costOverOutputGrad = ...
         tests{r}.costOverOutputGrad = ...
         (output_rowMat - targetOutput_rowMat) / m;
      costOverFeaturesGrad_analytic = calcs(input_rowMat, ...
features_rowMat).costOverNumericalFeaturesGrad_thruCostOverOutputGrad(costOverOutputGrad);
      costOverFeaturesGrad_numerical = gradApprox...
         (@(features_rowMat) costFuncAvg_sqErr...
         (calcs(input_rowMat, features_rowMat).val, ...
         targetOutput_rowMat).val, features_rowMat);

      eqT = equalTest(costOverFeaturesGrad_numerical, ...
         costOverFeaturesGrad_analytic, prec);

      comps{r} = tests{r}.comp = ...
         [costOverFeaturesGrad_numerical; ...
         NA([1 columns(features_rowMat)]); ...
         costOverFeaturesGrad_analytic];

      if (eqT)
         succs++;
      else
         fails = [fails r];
      endif

    
   endfor

   results.tests = tests;
   results.summs = summs;
   results.comps = comps;
   results.succs = succs;
   results.fails = fails;

   fprintf('\n\n%i Successes out of %i Runs\n', succs, numRuns);

end