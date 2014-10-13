function f = convertText_toTransformFunc(transformFunc_name)

   switch (transformFunc_name)
   
      case ('linear')
         f = linear_transformFuncHandles;
      case ('linearNoBias')
         f = linear_transformFuncHandles(false);

      case ('logistic')
         f = logistic_transformFuncHandles;
      case ('logisticNoBias')
         f = logistic_transformFuncHandles(false);

      case ('softmax')
         f = softmax_transformFuncHandles;
      case ('softmaxNoBias')
         f = softmax_transformFuncHandles(false);
         
      case ('embedClassIndices_inRealFeatures')
         f = embedClassIndcs_inRealFeats_transformFuncHandles;

   endswitch

endfunction