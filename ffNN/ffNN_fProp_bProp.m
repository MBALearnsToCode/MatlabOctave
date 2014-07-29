function f = ffNN_fProp_bProp(ffNN, input_Arr, ...
   targetOutput_rowMat = [], ...
   targetOutput_isClassIndcsColVec_ofNumClasses = 0, ...
   paramRegulArgs_list = {{'L2'} []}, bProp = true, ...
   timeScale = 1e-3)
   
   f = ffNN;
   numLayers = f.numLayers;   
   f.activs{1} = activs{1} = input_Arr;
   m = size(input_Arr, 1);
   f.costAvg_wRegul = f.costAvg_noRegul = ...
      paramRegulCostAvg = 0;
   
   paramRegulFuncs = [{{}} paramRegulArgs_list{1}];
   paramRegulParams = [0 paramRegulArgs_list{2}];
   paramRegul_byMacKay_empBayes_perLayer = ...
      false([1 numLayers]);
   paramRegul_byMacKay_empBayes = false;   
   
   for (l = 2 : numLayers)
      
      if (length(paramRegulFuncs) < l)
         paramRegulFuncs{l} = paramRegulFuncs{l - 1};
      endif
      if strcmp(paramRegulFuncs{l}, ...
         const_MacKay_empBayes_str)
         paramRegul_byMacKay_empBayes = ...
            paramRegul_byMacKay_empBayes_perLayer(l) = true;
      end
      f.regulFuncs{l} = paramRegulFuncs{l} = ...
         ffNN_definedRegulFunc(paramRegulFuncs{l});
            
      if (length(paramRegulParams) < l)
         paramRegulParams(l) = paramRegulParams(l - 1);
      endif
      f.regulParams(l) = paramRegulParams(l);
      
   endfor      
   
   takeTime = {};
   takeTime.fProp_bProp = 0;
   
   % FORWARD-PROPAGATE TO UPDATE ACTIVITIES
   % --------------------------------------
   returnDeriv = true([1 (numLayers - 1)]);
   returnDeriv(numLayers) = false;
   % unnecessary to calculate output layer's derivatives
   % because signal gradients can be computed directly
     
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
      if (targetOutput_isClassIndcsColVec_ofNumClasses)
         targetOutput = convertClassIndcsColVec_toRowMat...
            (targetOutput_rowMat, ...
            targetOutput_isClassIndcsColVec_ofNumClasses);
      else
         targetOutput = targetOutput_rowMat;
      endif
      f.costAvg_noRegul = costAvg_noRegul = ...
         costFuncAvgCalcs(hypoOutput, targetOutput, 0, ...
         f.costFuncType, false).val;
      takeTime_stop = time;
      takeTime.fProp_bProp += takeTime.costAvg = ...
         (takeTime_stop - takeTime_start)/timeScale;
         
      outputError = hypoOutput - targetOutput;      
      if (paramRegul_byMacKay_empBayes)
         varOutputError = var(outputError(:));
      endif 
   
      for (l = 2 : numLayers)
                  
         param = params{l};
         
         if (paramRegul_byMacKay_empBayes_perLayer(l))            
            paramRegulParams(l) = f.regulParams(l) = ...
               div0(varOutputError, var(param(:)));
         endif
         paramRegulParam = paramRegulParams(l);
      
         takeTime_start = time;
         if (paramRegulParam)
            paramRegulCostAvg += paramRegulParam ...
               * paramRegulFuncs{l}(param, ...
               transformFuncs{l}.addBias).val;
         endif
         takeTime_stop = time;
         takeTime.fProp_bProp += takeTime.paramRegul(l) = ...
            (takeTime_stop - takeTime_start)/timeScale;
         
      endfor
         
      f.costAvg_wRegul = costAvg_noRegul + paramRegulCostAvg;      
 
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
            addBias = transformFunc.addBias;
            paramRegulFunc = paramRegulFuncs{l};
            paramRegulParam = paramRegulParams(l);
            
            if (l == numLayers)
               
               takeTime_start = time;
               f.signalGrads{l} = signalGrad = ...
                  outputError / m;
               takeTime_stop = time;
               takeTime.fProp_bProp += ...
                  takeTime.signalGrads(l) = ...
                  (takeTime_stop - takeTime_start)/timeScale;
 
               takeTime_start = time;
               f.paramGrads{l} = ...
                  addBiasElems(activ_below, addBias)' ...
                  * signalGrad;            
               if (paramRegulParam)
                  f.paramGrads{l} += paramRegulParam ...
                     * paramRegulFunc(param, addBias).grad;
               endif
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
                  (activGrad, activ_below, param);
               if (paramRegulParam > 0)
                  f.paramGrads{l} += paramRegulParam ...
                     * paramRegulFunc(param, addBias).grad;
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