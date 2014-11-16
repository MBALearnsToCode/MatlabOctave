function c = class_ffNN(inputDimSizes_perCase_vec, ...
   addlLayersNumsNodes_vec_OR_weightDimSizes_list = [], ...
   transformFuncs_list = {}, displayOverview = false, ...
   initWeights_rand = true, sigma_or_epsilon = 1e-3, ...
   distrib = 'normal')

   c.inputDimSizes_perCase = inputDimSizes_perCase_vec;   
   c.normalizeSubtract = 0;
   c.normalizeDivide = 1;
   c.numTransforms = 0;
   c.transformFuncs = {};
   c.weightDimSizes = {};
   c.weights = {};
   c.numWeights = 0;
   c.costFuncType = '';
   c = class(c, 'class_ffNN');   

   if iscell...
      (addlLayersNumsNodes_vec_OR_weightDimSizes_list)      
      weightDimSizes = ...
         addlLayersNumsNodes_vec_OR_weightDimSizes_list;         
      numTransforms = length(weightDimSizes);
   else
      if isempty...
         (addlLayersNumsNodes_vec_OR_weightDimSizes_list)
         addlLayersNumsNodes_vec_OR_weightDimSizes_list = 1;
      endif
      numTransforms = ...
         length(addlLayersNumsNodes_vec_OR_weightDimSizes_list);      
      numsNodes = [inputDimSizes_perCase_vec ...
         addlLayersNumsNodes_vec_OR_weightDimSizes_list];      
   endif   

   transformFuncs = transformFuncs_list;
   numTransformFuncs_specified = length(transformFuncs_list);
   for (l = ...
      (numTransformFuncs_specified + 1) : (numTransforms - 1))
      transformFuncs{l} = 'tanh';
   endfor
   if (length(transformFuncs) == (numTransforms - 1))
      transformFuncs(numTransforms) = 'logistic';
   endif
      
   if ~iscell...
      (addlLayersNumsNodes_vec_OR_weightDimSizes_list)      
      for (l = 1 : numTransforms)
         if strcmp(class(transformFuncs{l}), 'char')
            transformFuncs{l} = ...
               convertText_toTransformFunc(transformFuncs{l});
         endif
         weightDimSizes{l} = ...
            [(numsNodes(l) + transformFuncs{l}.addBias) ...
            numsNodes(l + 1)];
      endfor
   endif

   if (numTransformFuncs_specified < numTransforms) && ...
      (weightDimSizes{numTransforms} > 2)
      if (transformFuncs{numTransforms}.addBias)
         transformFuncs{numTransforms} = 'softmax';
      else
         transformFuncs{numTransforms} = 'softmaxNoBias';         
      endif      
   endif
   
   for (l = 1 : numTransforms)
      c = addLayer(c, weightDimSizes{l}, transformFuncs{l});
   endfor  
   
   if (initWeights_rand)
      c = initWeights(c, sigma_or_epsilon, distrib);
   endif
   
   if (displayOverview)
      overview(c);
   endif
   
endfunction