function [costAvg_wRegul inputGrad_n_paramGrads_colVec] = ...
   ffNN_costAvgWRegul_n_inputGrad_n_paramGrads...
   (ffNN, input_n_params_colVec, targetOutput, ...
   targetOutput_isClassIndcsColVec_ofNumClasses = 0, ...
   paramRegulArgs_list = ...
      {{const_MacKay_empBayes_str} []}, ...
   returnInputGrad = true)
   
   NN = ffNN;
   numInputElems = length(input_n_params_colVec) ...
      - NN.numParams;   
   inputDimSizes_perCase = NN.inputDimSizes_perCase;   
   inputDimSizes = ...
      [(numInputElems / prod(inputDimSizes_perCase)) ...
      inputDimSizes_perCase];
   input_n_params = convertColVecToArrs...
      (input_n_params_colVec, ...
      [inputDimSizes NN.paramDimSizes]);
   input_rowMat = input_n_params{1};
   NN.params = input_n_params(2 : end);

   NN = ffNN_fProp_bProp...
      (NN, input_rowMat, targetOutput, ...
      targetOutput_isClassIndcsColVec_ofNumClasses, ...
      paramRegulArgs_list);

   costAvg_wRegul = NN.costAvg_wRegul;

   if (returnInputGrad)
      inputGrad_n_paramGrads_colVec = ...
         convertArrsToColVec...
         ([NN.activGrads{1} NN.paramGrads]);
   else
      inputGrad_n_paramGrads_colVec = ...
         convertArrsToColVec(NN.paramGrads);
   endif

end