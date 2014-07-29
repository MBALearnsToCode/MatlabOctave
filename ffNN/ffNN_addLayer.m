function f = ffNN_addLayer...
   (ffNN, paramDimSizes, transformFunc = ...
   funcLogistic_inputRowMat_n_biasWeightMat, ...
   regulFunc = @regulL2_Mat)
   
   f = ffNN;
   
   if strcmp(class(transformFunc), 'char')
      transformFunc = ...
         ffNN_definedTransformFunc(transformFunc);
   endif

   if strcmp(class(regulFunc), 'char')
      regulFunc = ffNN_definedRegulFunc(regulFunc);
   endif
   
   switch (transformFunc.funcType)

      case ('linear')
         f.costFuncType = 'SE';
 
      case ('logistic')
         f.costFuncType = 'CE-L';
  
      case ('softmax')
         f.costFuncType = 'CE-S';

   endswitch

   f.numLayers++;
   l = f.numLayers;
   f.numParams += ...
      ~isempty(paramDimSizes) * prod(paramDimSizes);
   f.paramDimSizes{l} = paramDimSizes;
   f.transformFuncs{l} = transformFunc;
   f.regulFuncs{l} = regulFunc;
   f.paramGrads{l} = f.params{l} = ...
      zeros(paramDimSizes);
   f.activGrads{l} = f.activs{l} = ...
      f.signalGrads{l} = [];
   f.regulParams(l) = 0;

end