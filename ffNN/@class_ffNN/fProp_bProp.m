function [weightGrads costAvg_exclWeightPenalty ...
   costAvg_inclWeightPenalty hypoOutput accuracyAvg ...
   activs weightRegulParams timeStats] = fProp_bProp(ffNN, ...
   input_Arr, targetOutputs_rowMats_args = [], ...
targetOutputs_areClassIndcsColVecs_ofNumClasses = false, ...
   classSkewnesses = [1], weightRegulArgs_list = {{'L2'} [0]}, ...
   bProp = true, connectivitiesOnOff = {1.0}, timeScale = 1e-3)
   
   numTransforms = ffNN.numTransforms;
   weightDimSizes = ffNN.weightDimSizes;
   costFuncType = ffNN.costFuncType;   
   
   m = size(input_Arr, 1);
   n = weightDimSizes{numTransforms}(2);
   
   costFuncType_isCrossEntropy = ...
      strcmp(costFuncType, 'CE-L') || ...
      strcmp(costFuncType, 'CE-S');
   for (j = (length(classSkewnesses) + 1) : n)
      classSkewnesses(j) = classSkewnesses(j - 1);
   endfor
   if strcmp(costFuncType, 'CE-S')      
      classSkewnesses /= sum(classSkewnesses) / n;
   endif   
   
   weightGrads = {};
   costAvg_inclRegulPenalty = weightRegulCost = ...
      costAvg_exclRegulPenalty = 0;
   accuracyAvg = 0;
   
   weightRegulFuncs = weightRegulArgs_list{1};
   weightRegulParams = weightRegulArgs_list{2};
   weightRegul_byMacKay_empBayes_perLayer = ...
      false([1 numTransforms]);
   weightRegul_byMacKay_empBayes = false;
   
   for (l = 2 : numTransforms)
      if (length(weightRegulFuncs) < l)
         weightRegulFuncs{l} = weightRegulFuncs{l - 1};
      endif
      if (length(weightRegulParams) < l)
         weightRegulParams(l) = weightRegulParams(l - 1);
      endif      
   endfor
  
   for (l = 1 : numTransforms)
      weightRegulFunc = weightRegulFuncs{l};
      if strcmp(weightRegulFunc, const_MacKay_empBayes_str)
         weightRegul_byMacKay_empBayes = ...
            weightRegul_byMacKay_empBayes_perLayer(l) = true;
      endif      
      if strcmp(class(weightRegulFunc), 'char')
         weightRegulFuncs{l} = ...
            convertText_toRegulFunc(weightRegulFunc);
      endif
      if (l > 1) && (length(connectivitiesOnOff) < l)
         connectivitiesOnOff{l} = connectivitiesOnOff{l - 1};
      endif
   endfor   
   
   if isempty(targetOutputs_rowMats_args)
      bProp = false;
   endif   
   returnDeriv = bProp * true([1 (numTransforms - 1)]);
   returnDeriv(numTransforms) = false;
   % unnecessary to calculate output layer's derivatives
   % because signal gradients can be computed directly
   
   timeStats.fProp_bProp = 0;

   tic;
   func_convertInput = ffNN.func_convertInput;
   input_Arr = func_convertInput(input_Arr);   
   activs{1} = normalizeSubtractDivide(input_Arr, ...
      ffNN.normalizeSubtract, ffNN.normalizeDivide);
   timeStats.fProp_bProp += timeStats.activs(1) = ...
      toc / timeScale;
   
   % FORWARD-PROPAGATE TO UPDATE ACTIVITIES
   % --------------------------------------     
   for (l = 1 : numTransforms)
         
      transformFunc = ffNN.transformFuncs{l};
      func_signal = transformFunc.func_signal;
      func_output_effDeriv = ...
         transformFunc.func_output_effDeriv;
         
      tic;
      effWeight = effWeights{l} = ...
         connectivitiesOnOff{l} .* ffNN.weights{l};
      signals{l} = signal = func_signal(activs{l}, effWeight);
            
      timeStats.fProp_bProp += timeStats.signals(l) = ...
         toc / timeScale;
         
      tic;
      if returnDeriv(l)
         outputCalcs = func_output_effDeriv(signal, true);
         activs{l + 1} = outputCalcs.val;
         derivs{l} = outputCalcs.deriv;
      else
         activs{l + 1} = func_output_effDeriv...
            (signal, false).val;
      endif
      timeStats.fProp_bProp += timeStats.activs(l + 1) = ...
         toc / timeScale;
   
   endfor
   
   % UPDATE HYPO OUTPUT
   % ------------------
   hypoOutput = activs{numTransforms + 1};

   % CONTINUE IF TARGET OUTPUT IS PROVIDED
   % -------------------------------------
   if ~isempty(targetOutputs_rowMats_args)

      % COMPUTE COST FUNCTION
      % AND TOP-LAYER ACTIVITY GRADIENT
      % -------------------------------
      tic;
      [costAvg_exclWeightPenalty_calcs ...
         weightedTargetOutput] = costFuncAvgCalcs...
         (hypoOutput, targetOutputs_rowMats_args, ...
         targetOutputs_areClassIndcsColVecs_ofNumClasses, ...
         classSkewnesses, costFuncType, false);
      costAvg_exclWeightPenalty = ...
         costAvg_exclWeightPenalty_calcs.val;
      if (costFuncType_isCrossEntropy)
         accuracyAvg = ...
            costAvg_exclWeightPenalty_calcs.accuracyAvg;
      endif
      timeStats.fProp_bProp += timeStats.costAvg = ...
         toc / timeScale;      
       
      outputError = hypoOutput - weightedTargetOutput;      
       
      if (weightRegul_byMacKay_empBayes)
         varOutputError = var(outputError(:));
      endif 
   
      for (l = 1 : numTransforms)
                  
         transformFunc = ffNN.transformFuncs{l};
         effWeight = effWeights{l};
         
         if (weightRegul_byMacKay_empBayes_perLayer(l))            
            weightRegulParams(l) = ...
               div0(varOutputError, var(effWeight(:)));
         endif
         weightRegulParam = weightRegulParams(l);
      
         tic;
         if (weightRegulParam)            
            if (bProp)               
               weightRegulCalcs = weightRegulFuncs{l}...
                  (effWeight, transformFunc.addBias, true);
               weightRegulCost += weightRegulParam ...
                  * weightRegulCalcs.val;
               weightRegulGrads{l} = weightRegulParam ...
                  * weightRegulCalcs.grad;
            else
               weightRegulCost += weightRegulParam ...
                  * weightRegulFuncs{l}(effWeight, ...
                  transformFunc.addBias, false).val;
            endif
         else
            weightRegulGrads{l} = 0;        
         endif
         timeStats.fProp_bProp += ...
            timeStats.weightRegul(l) = toc / timeScale;
         
      endfor
         
      costAvg_inclWeightPenalty = ...
         costAvg_exclWeightPenalty + weightRegulCost;      
 
      % f.activGrads{numLayers} = activGrads{numLayers} = ...
      %   costCalcs.grad;
      % (UNNECESSARY AS SIGNAL GRADIENT IS DIRECTLY COMPUTED)
      
      % CONTINUE IF bProp == true
      % -------------------------
      if (bProp)
 
         % BACKWARD-PROPAGATE
         % TO UPDATE ACTIVITY GRADIENTS,
         % SIGNAL GRADIENTS & WEIGHT GRADIENTS
         % --------------------------------------
         for (l = fliplr(1 : numTransforms))

            activ_below = activs{l};
            effWeight = effWeights{l};
            transformFunc = ffNN.transformFuncs{l};            
            addBias = transformFunc.addBias;
            weightRegulFunc = weightRegulFuncs{l};
            weightRegulParam = weightRegulParams(l);
            
            if (l == numTransforms)               
                
               tic;   
               signalGrads{l} = signalGrad = ...
                  costOverSignalGrad...
                  (hypoOutput, weightedTargetOutput, ...
                  costFuncType, classSkewnesses);
               timeStats.fProp_bProp += ...
                  timeStats.signalGrads(numTransforms) = ...
                  toc / timeScale;
         
               tic;
               weightGrads{l} = connectivitiesOnOff{l} ...
                  .* (addBiasElems(activ_below, addBias)' ...
                  * signalGrad) + weightRegulGrads{l};               
               timeStats.fProp_bProp += ...
                  timeStats.weightGrads(l) = toc / timeScale;
              
               if (l > 1)
                  tic;
                  activGrads{l} = signalGrad ...
                     * rmBiasElems(effWeight, addBias)';
                  timeStats.fProp_bProp += ...
                     timeStats.activGrads(l) = ...
                     toc / timeScale;
               endif
 
            else

               activGrad = activGrads{l + 1};
               
               tic;
         func_costOverSignalGrad_thruCostOverOutputGrad = ...
transformFunc.func_costOverSignalGrad_thruCostOverOutputGrad;
               signalGrads{l} = ...
            func_costOverSignalGrad_thruCostOverOutputGrad...
                  (activGrad, derivs{l});               
               timeStats.fProp_bProp += ...
                  timeStats.signalGrads(l) = toc / timeScale;

               tic;
         func_costOverWeightGrad_thruCostOverSignalGrad = ...
transformFunc.func_costOverWeightGrad_thruCostOverSignalGrad;
               weightGrads{l} = connectivitiesOnOff{l} ...
         .* func_costOverWeightGrad_thruCostOverSignalGrad...
                  (signalGrads{l}, activ_below, effWeight) ...
                  + weightRegulGrads{l};
               timeStats.fProp_bProp += ...
                  timeStats.weightGrads(l) = toc / timeScale;
               
               if (l > 1)
                  tic;
         func_costOverInputGrad_thruCostOverSignalGrad = ...
transformFunc.func_costOverInputGrad_thruCostOverSignalGrad;
                  activGrads{l} = ...
            func_costOverInputGrad_thruCostOverSignalGrad...
                  (signalGrads{l}, activ_below, effWeight);
                  timeStats.fProp_bProp += ...
                     timeStats.activGrads(l) = ...
                     toc / timeScale;
               endif
               
            endif
            
         endfor

      endif
  
   endif   
   
endfunction