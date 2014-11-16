function f = convertTransformFunc_toText(transformFunc)

   switch (transformFunc.funcType)
   
      case ('linear')
         f = 'linear';
         if ~(transformFunc.addBias)
            f = strcat(f, 'NoBias');
         endif
      
      case ('logistic')
         f = 'logistic';
         if ~(transformFunc.addBias)
            f = strcat(f, 'NoBias');
         endif
         
      case ('tanh')
         f = 'tanh';
         if ~(transformFunc.addBias)
            f = strcat(f, 'NoBias');
         endif
         
      case ('softmax')
         f = 'softmax';
         if ~(transformFunc.addBias)
            f = strcat(f, 'NoBias');
         endif
         
      case ('Embed Class Indices in Real Features')      
         f = 'embedClassIndices_inRealFeatures';      
      
   endswitch   

endfunction