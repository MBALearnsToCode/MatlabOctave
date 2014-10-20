function f = ffNN_predict(input_rowMat, ffNN, ...
   givenParams = {}, returnIndices = true, binThreshold = 0.5)

   NN = ffNN;

   if ~isempty(givenParams)      
      NN.params = [NN.params{1} givenParams];
   endif

   f = ffNN_fProp_bProp(NN, input_rowMat).hypoOutput;

   switch (NN.costFuncType)
   
      case ('CE-L')
         f = predictBinClass(f, binThres
         
      case ('CE-S')
         f = predictClass_rowMat(f, returnIndices);
         
   endif

end