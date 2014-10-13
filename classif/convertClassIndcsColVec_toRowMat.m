function f = convertClassIndcsColVec_toRowMat...
   (classIndcs_colVec, numClasses = false)
   
   if (numClasses)   
      f = eye(numClasses)(classIndcs_colVec, :);
   else
      f = classIndcs_colVec;
   endif
   
endfunction