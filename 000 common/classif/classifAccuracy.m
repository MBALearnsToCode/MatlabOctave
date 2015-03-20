function f = classifAccuracy...
   (prediction_rowMat, targetOutput_rowMat, numClasses = false);

   if (columns(prediction_rowMat) > 1)
      [~, prediction_colVec] = max(prediction_rowMat, [], 2);
   else
      prediction_colVec = prediction_rowMat;
   endif
   
   if (columns(targetOutput_rowMat) > 1)
      [~, targetOutput_colVec] = max(targetOutput_rowMat, [], 2);
   else
      targetOutput_colVec = targetOutput_rowMat;
   endif
   
   f = mean(double(prediction_colVec == targetOutput_colVec));

endfunction