function f = convertClassIndcsColVec_toRowMat...
   (classIndcs_colVec, numClasses = 0)
   
   numClasses_adj = max(numClasses, max(classIndcs_colVec));   
   f = eye(numClasses_adj)(classIndcs_colVec, :);
   
end