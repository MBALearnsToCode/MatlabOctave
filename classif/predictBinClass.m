function f = predictBinClass(probs_Arr, binThreshold = 0.5)
   
   f = probs_Arr >= binThreshold;
   
end