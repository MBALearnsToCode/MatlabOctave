function m = addLayer(ffNN, weightDimSizes, ...
   transformFunc = logistic_transformFuncHandle)
   
   m = ffNN;
   m.numTransforms++;
   numTransforms = m.numTransforms;
   
   if strcmp(class(transformFunc), 'char')
      transformFunc = convertText_toTransformFunc...
         (transformFunc);   
   endif
   
   m.transformFuncs{numTransforms} = transformFunc;
   
   m.weightDimSizes{numTransforms} = weightDimSizes;
   
   m.weights{numTransforms} = zeros(weightDimSizes);

   m.numWeights += ...
      ~isempty(weightDimSizes) * prod(weightDimSizes);
   
   m.costFuncType = costFuncType_forTransformFuncType...
      (transformFunc.funcType);
      
end