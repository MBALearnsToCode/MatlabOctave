function f = ffNN_new(inputDimSizes_perCase_vec, ...
   addlLayersNumsNodes_vec_OR_paramDimSizes_list = [], ...
   transformFuncs_list = {}, overview = true, ...
   initParams = true, sigma_or_epsilon = 1e-2, ...
   distrib = 'normal')
   
   f.hypoOutput = [];
   f.costFuncType = '';
   f.costAvg_wRegul = f.costAvg_noRegul = 0;
   f.numLayers = 1;
   f.numParams = 0;
   f.inputDimSizes_perCase = inputDimSizes_perCase_vec;
   f.paramDimSizes{1} = [0 0];
   f.transformFuncs{1} = {};
   f.activGrads{1} = f.activs{1} = f.signalGrads{1} = ...
      f.paramGrads{1} = f.params{1} = [];
   
   if iscell...
      (addlLayersNumsNodes_vec_OR_paramDimSizes_list)
      
      if isempty...
         (addlLayersNumsNodes_vec_OR_paramDimSizes_list)
         return;
      endif
      
      paramDimSizes = [[] ...
         addlLayersNumsNodes_vec_OR_paramDimSizes_list];
      numLayers = length(paramDimSizes);
      
   else

      numsNodes = [inputDimSizes_perCase_vec ...
         addlLayersNumsNodes_vec_OR_paramDimSizes_list];
      if isscalar(numsNodes)
         numsNodes = [numsNodes 1];
      endif
      numLayers = length(numsNodes);
      for (l = 2 : numLayers)
         paramDimSizes{l} = ...
            [(numsNodes(l - 1) + 1) numsNodes(l)];
      endfor      
      
   endif
   
   transformFuncs = [{{}} transformFuncs_list];
     
   for (l = ...
      (length(transformFuncs) + 1) : (numLayers - 1))
      transformFuncs{l} = 'logistic';
   endfor
   
   if (length(transformFuncs) == (numLayers - 1))
   
      if (paramDimSizes{numLayers}(2) <= 2)
         transformFuncs{numLayers} = 'logistic';
      else
         transformFuncs{numLayers} = 'softmax';
      endif
      
   endif
   
   for (l = 2 : numLayers)
      f = ffNN_addLayer(f, paramDimSizes{l}, ...
         transformFuncs{l});
   endfor

   if (initParams)
      f = ffNN_initParams(f, sigma_or_epsilon, distrib);
   endif
   
   if (overview)
      ffNN_overview(f);
   endif    

end