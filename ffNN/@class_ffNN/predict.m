function m = predict(ffNN, input_Arr, givenWeights = {}, ...
   returnIndices = true, binThreshold = 0.5)

   if ~isempty(givenWeights)      
      ffNN.weights = givenWeights;
   endif

   [~, ~, ~, m] = fProp_bProp(ffNN, input_Arr);
   
   switch (ffNN.costFuncType)      
      case ('CE-L')
         m = predictBinClass(m, binThreshold);         
      case ('CE-S')
         m = predictClass_rowMat(m, returnIndices);         
   endswitch

endfunction