function results = zzzTest_ffNN_gradChk...
   (numRuns = 1, ffNN_given = {}, perturb = 1e-6, prec = 1e-6)
  
   % PARAMETERS
   % ----------
   maxNumCases = 3;
   maxNumLayersExclInputOrEmbed = 3;
   maxNumNodesPerLayer = 3;
   maxNumInputClasses = 3;
   maxNumInputEmbedFeatures = 3;
   maxNumTargetOutputs = 3;
   inputMagnOrder = 1e1;
   initParamMagnOrder = 1e-1;

   succsAbs = 0; failsAbs = [];
   succsRel = 0; failsRel = [];

   fprintf('\nPertubance Magnitude = %g\n', perturb);
   fprintf('Avg Precision Tested for = %g\n', prec);   
   
   for (r = 1 : numRuns)

      fprintf('\rTest #%i', r);

      % SET MODEL STRUCTURE
      % -------------------
      if isempty(ffNN_given)
               
         transformFuncs = weightDimSizes = regulFuncs = {};
         regulParams = [];

         numsNodes(1) = nI = unidrnd(maxNumNodesPerLayer);
         % SET featEmbed
         % -------------
         featEmbed = randElem([true false]);
         
         if (featEmbed)         
            nC = unidrnd(maxNumInputClasses);
            nF = unidrnd(maxNumInputEmbedFeatures);
            weightDimSizes{1} = [nC nF];
            transformFuncs{1} = ...
               embedClassIndcs_inRealFeats_transformFuncHandles;
            numsNodes(2) = nI * nF;
         else         
            numsNodes(2) = unidrnd(maxNumNodesPerLayer);
            addBias = rand > 0.5;
            weightDimSizes{1} = ...
               [(numsNodes(1) + addBias) numsNodes(2)];
            transformFuncs{1} = randElem...
               ({linear_transformFuncHandles(addBias) ...
               logistic_transformFuncHandles(addBias) ...
               softmax_transformFuncHandles(addBias)});            
         endif
         
         regulFuncs{1} = randElem({'L1' 'L2' ...
            const_MacKay_empBayes_str}); 
         regulParams(1) = randElem(const_regulParams_10);                 
         
         for (k = ...
            2 : (1 + unidrnd(maxNumLayersExclInputOrEmbed)))         
            numsNodes(k + 1) = unidrnd(maxNumNodesPerLayer);
            addBias = rand > 0.5;
            weightDimSizes{k} = ...
               [(numsNodes(k) + addBias) numsNodes(k + 1)];
            transformFuncs{k} = randElem...
               ({linear_transformFuncHandles(addBias) ...
               logistic_transformFuncHandles(addBias) ...
               softmax_transformFuncHandles(addBias)});
            regulFuncs{k} = randElem({'L1' 'L2' ...
               const_MacKay_empBayes_str}); 
            regulParams(k) = randElem(const_regulParams_10);            
         endfor
         
         ffNN = class_ffNN(nI, weightDimSizes, ...
            transformFuncs, false, true, initParamMagnOrder);
            
         m = unidrnd(maxNumCases);
         
         if (featEmbed)
            input_Arr = tests{r}.input_Arr = ...
               unidrnd(nC, [m nI]);
            w = ffNN.weights;
            ffNN.weights{1} = ...
               (inputMagnOrder / initParamMagnOrder) * w{1};
         else
            input_Arr = tests{r}.input_Arr = ...
               randUnif([m nI], inputMagnOrder);
         endif
         
      else
      
         ffNN = ffNN_given;
         m = unidrnd(maxNumCases);
         inputDimSizes_perCase = ffNN.inputDimSizes_perCase;
         input_Arr = tests{r}.input_Arr = ...
            randUnif([m inputDimSizes_perCase], ...
            inputMagnOrder);
         
      endif  
   
      % RANDOMIZE TARGET OUTPUT 
      % -----------------------
      numTargetOutputs = unidrnd(maxNumTargetOutputs);
      outputWeightDimSizes = ffNN.weightDimSizes;
      nO = outputWeightDimSizes{ffNN.numTransforms}(2);
      targetOutputs_rowMats_list = {};
      targetOutputs_weightages = [];
      if strcmp(ffNN.costFuncType, 'CE-S')
         for (t = 1 : numTargetOutputs)
            targetOutputs_rowMats_list{t} = ...
               tests{r}.targetOutputs_rowMats_list{t} = ...         
               predictClass_rowMat(rand([m nO]));
            targetOutputs_weightages(t) = rand;
         endfor
      else
         for (t = 1 : numTargetOutputs)
            targetOutputs_rowMats_list{t} = ...
               tests{r}.targetOutputs_rowMats_list{t} = ...         
               randUnif([m nO]) > 0;
            targetOutputs_weightages(t) = rand;
         endfor
      endif
      targetOutputs_rowMats_args = ...
         {targetOutputs_rowMats_list ...
         targetOutputs_weightages};
         
      % COMPUTE ANALYTIC GRADIENTS
      % --------------------------
      [weightGrads, ~, ~, ~, ~, weightRegulParams] = ...
         fProp_bProp(ffNN, input_Arr, ...
         targetOutputs_rowMats_args, false, ...
         {regulFuncs regulParams}, true);
      
      aGrad = tests{r}.aGrad = ...
         convertArrsToColVec(weightGrads);      

      % COMPUTE NUMERICAL GRADIENTS
      % ---------------------------
      regulFuncs2 = regulFuncs;
      for (k = 1 : length(regulFuncs2))
         if strcmp(regulFuncs2{k}, ...
            const_MacKay_empBayes_str)
            regulFuncs2{k} = 'L2';
         endif
      endfor
      regulParams2 = weightRegulParams;
      costAvgFunc = @(w_v) ...
         costAvgInclWeightPenalty_n_weightGrads...
         (ffNN, w_v, input_Arr, ...
         targetOutputs_rowMats_args, false, ...
         {regulFuncs2 regulParams2}, false);
      nGrad = tests{r}.nGrad = gradApprox(costAvgFunc, ...
            convertArrsToColVec(ffNN.weights), perturb);
      
      % COMPARE GRADIENTS  
      % -----------------
      tests{r}.gradAbsEqTest = ...
         equalTest(nGrad, aGrad, prec, 'abs');
      
      [tests{r}.gradRelEqTest tests{r}.gradRelD ...
      tests{r}.gradAvgAbsD tests{r}.gradMaxAbsD] = ...
         equalTest(nGrad, aGrad, prec);

      if tests{r}.gradAbsEqTest 
         succsAbs++;    
      else
         failsAbs = [failsAbs r];     
      endif

      if tests{r}.gradRelEqTest
         succsRel++;
      else
         failsRel = [failsRel r]; 
      endif

   endfor

   results.numRuns = numRuns;
   results.tests = tests;
   results.succsAbsPct = succsAbs / numRuns * 100;
   results.failsAbs = failsAbs;
   results.succsRelPct = succsRel / numRuns * 100;
   results.failsRel = failsRel;

   fprintf('\n\nAbsolute Comparison Success Percent: %g\n', ...
      results.succsAbsPct);
   fprintf('   abs fails:\n');

   for i = failsAbs
      fprintf(' %i (%g)', i, tests{i}.gradAvgAbsD);
   endfor

   fprintf('\nRelative Comparison Success Percent: %g\n', ...
      results.succsRelPct);
   fprintf('   rel fails:\n');

   for i = failsRel
      fprintf(' %i (%g)', i, tests{i}.gradRelD);
   endfor

   fprintf('\n');
   
endfunction