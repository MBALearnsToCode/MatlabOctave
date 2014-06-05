function f = ffNN_fProp_bProp(input_Arr, ffNN, ...
   targetOutput_rowMat = [], regulParam = 0, bProp = true, ...
   timeScale = 1e-3)
   
   f = ffNN;
   numLayers = f.numLayers;
   f.activs{1} = activs{1} = input_Arr;
   m = size(input_Arr, 1);
   paramRegulCostAvg = 0;
   takeTime = {};
   takeTime.fProp_bProp = 0;
   
   % FORWARD-PROPAGATE TO UPDATE ACTIVITIES
   % --------------------------------------
   returnDeriv = true([1 (numLayers - 1)]);
   % unnecessary to calculate output layer's derivatives
   % because signal gradients can be computed directly
   returnDeriv(numLayers) = false;  
   for (l = 2 : numLayers)
   
      param = params{l} = f.params{l};
      transformFunc = transformFuncs{l} = ...
         f.transformFuncs{l};
      
      takeTime_start = time;
      f.activs{l} = activs{l} = ...
         transformFunc.funcOutputVal...
         (activs{l - 1}, param, returnDeriv(l));
      takeTime_stop = time;
      takeTime.fProp_bProp += takeTime.activs(l) = ...
         (takeTime_stop - takeTime_start)/timeScale;
      
      takeTime_start = time;
      if (regulParam)
         paramRegulCostAvg += ...
            transformFunc.funcParamRegulCostAvg...
            (param, regulParam, m);
      endif
      takeTime_stop = time;
      takeTime.fProp_bProp += takeTime.paramRegul(l) = ...
         (takeTime_stop - takeTime_start)/timeScale;
   
   endfor

   % UPDATE HYPO OUTPUT
   % ------------------
   f.hypoOutput = hypoOutput = f.activs{numLayers};

   % CONTINUE IF TARGET OUTPUT IS PROVIDED
   % -------------------------------------
   if ~isempty(targetOutput_rowMat)

      % COMPUTE COST FUNCTION
      % AND TOP-LAYER ACTIVITY GRADIENT
      % -------------------------------
      takeTime_start = time;
      f.costAvg_noRegul = costAvg_noRegul = ...
         costFuncAvgCalcs(hypoOutput, targetOutput_rowMat, ...
         f.costFuncType, false).val;
      f.costAvg_wRegul = costAvg_noRegul + paramRegulCostAvg;
      takeTime_stop = time;
      takeTime.fProp_bProp += takeTime.costAvg = ...
         (takeTime_stop - takeTime_start)/timeScale;
 
      % f.activGrads{numLayers} = activGrads{numLayers} = ...
      %   costCalcs.grad;
      % (UNNECESSARY AS SIGNAL GRADIENT IS DIRECTLY COMPUTED)
      
      % CONTINUE IF bProp == true
      % -------------------------
      if (bProp)
 
         % BACKWARD-PROPAGATE
         % TO UPDATE ACTIVITY GRADIENTS,
         % SIGNAL GRADIENTS & PARAMETER GRADIENTS
         % --------------------------------------
         for (l = fliplr(2 : numLayers))

            activ_below = activs{l - 1};
            param = params{l};
            transformFunc = transformFuncs{l};            
            
            if (l == numLayers)

               takeTime_start = time;
               f.signalGrads{l} = signalGrad = ...
                  (hypoOutput - targetOutput_rowMat) / m;
               takeTime_stop = time;
               takeTime.fProp_bProp += ...
                  takeTime.signalGrads(l) = ...
                  (takeTime_stop - takeTime_start)/timeScale;
                 
               addBias = transformFunc.addBias;
 
               takeTime_start = time;
               f.paramGrads{l} = ...
                  addBiasElems(activ_below, addBias)' ...
                  * signalGrad + regulParam ...
                  * zeroBiasElems(param, addBias) / m;
               takeTime_stop = time;
               takeTime.fProp_bProp += ...
                  takeTime.paramGrads(l) = ...
                  (takeTime_stop - takeTime_start)/timeScale;
              
               takeTime_start = time;
               f.activGrads{l - 1} = activGrads{l - 1} = ...
                  signalGrad * rmBiasElems(param, addBias)';
               takeTime_stop = time;
               takeTime.fProp_bProp += ...
                  takeTime.activGrads(l - 1) = ...
                  (takeTime_stop - takeTime_start)/timeScale;
 
            else

               activGrad = activGrads{l};
               
               takeTime_start = time;
               f.signalGrads{l} = ...
transformFunc.funcCostOverSignalGrad_thruCostOverOutputGrad...
                  (activGrad, activ_below, param);
               takeTime_stop = time;
               takeTime.fProp_bProp += ...
                  takeTime.signalGrads(l) = ...
                  (takeTime_stop - takeTime_start)/timeScale;

               takeTime_start = time;
               f.paramGrads{l} = ...
transformFunc.funcCostOverParamGrad_thruCostOverOutputGrad...
                  (activGrad, activ_below, param); ...
               if (regulParam)
                  f.paramGrads{l} += ...
               transformFunc.funcParamRegulCostAvgGrad...
                     (param, regulParam, m);
               endif
               takeTime_stop = time;
               takeTime.fProp_bProp += ...
                  takeTime.paramGrads(l) = ...
                  (takeTime_stop - takeTime_start)/timeScale;
               
               takeTime_start = time;
               f.activGrads{l - 1} = activGrads{l - 1} = ...
transformFunc.funcCostOverInputGrad_thruCostOverOutputGrad...
                  (activGrad, activ_below, param);
               takeTime_stop = time;
               takeTime.fProp_bProp += ...
                  takeTime.activGrads(l - 1) = ...
                  (takeTime_stop - takeTime_start)/timeScale;
               
            endif
               
         endfor

      endif
  
   endif
   
   f.takeTime = takeTime;
   
end