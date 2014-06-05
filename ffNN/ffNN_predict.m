function f = ffNN_predict(input_rowMat, ffNN, ...
   givenParams = {}, returnIndices = true)

   NN = ffNN;

   if ~isempty(givenParams)      
      NN.params = [NN.params{1} givenParams];
   endif

   f = ffNN_fProp_bProp(input_rowMat, NN).hypoOutput;

   if ~strcmp...
      (NN.transformFuncs{NN.numLayers}.funcType, 'linear')
      f = predictClass_rowMat(f, returnIndices);
   endif

end