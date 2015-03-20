function f = binClassifAccuracy...
   (prediction_Arr, targetOutput_Arr, binThreshold = 0.5);

   prediction_colVec = (prediction_Arr >= binThreshold)(:);
   targetOutput_colVec = (targetOutput_Arr >= binThreshold)(:);
   f = mean(double(prediction_colVec == targetOutput_colVec));

endfunction