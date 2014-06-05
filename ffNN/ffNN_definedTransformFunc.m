function f = ffNN_definedTransformFunc(nameOfFunc)

   switch (nameOfFunc)
   
      case ('linear')
         f = funcLinear_inputRowMat_n_biasWeightMat;
      
      case ('linearNoBias')
         f = funcLinear_inputRowMat_n_biasWeightMat(false);
         
      case ('logistic')
         f = funcLogistic_inputRowMat_n_biasWeightMat;
         
      case ('logisticNoBias')
         f = funcLogistic_inputRowMat_n_biasWeightMat(false);

      case ('softmax')
         f = funcSoftmax_inputRowMat_n_biasWeightMat;
         
      case ('softmaxNoBias')
         f = funcSoftmax_inputRowMat_n_biasWeightMat(false);

      case ('embedClassIndices_inRealFeatures')
         f = funcEmbedClassIndcs_inRealFeats_rowMat;

   endswitch
       
end