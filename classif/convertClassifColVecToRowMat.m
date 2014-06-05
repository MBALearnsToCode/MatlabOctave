function f = convertClassifColVecToRowMat...
   (classes_vec, numClasses = 0)
   
   numClasses_adj = max(numClasses, max(classes_vec));   
   f = eye(numClasses_adj)(classes_vec, :);
   
end