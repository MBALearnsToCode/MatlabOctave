function [cI cJ] = svm_pairSMO(c_colVec, i, j, ...
   yI, yJ, softMarginConst, inputKernMat)
        
   coeff2 = (inputKernMat(i, i) + inputKernMat(j, j) ...
      - 2 * inputKernMat(i, j)) / 2;

   if (coeff2 <= 0)
      cI = c_colVec(i);
      cJ = c_colVec(j);
      return;
   endif
   
   fixedSum = c_colVec(i) + c_colVec(j);
   lowerBound_cI = max(min(0, yI * softMarginConst), ...
      min(fixedSum, fixedSum - yJ * softMarginConst));
   upperBound_cI = min(max(0, yI * softMarginConst), ...
      max(fixedSum, fixedSum - yJ * softMarginConst));

   c_temp = c_colVec;
   c_temp(i) = 0;
   c_temp(j) = fixedSum;        
     
   coeff1 = sum(c_temp ...
      .* (inputKernMat(:, i) - inputKernMat(:, j))) ...
      - yI + yJ;
            
   cI = quadraticOptim(coeff2, coeff1, 0, ...
      [lowerBound_cI upperBound_cI]);       
   cJ = fixedSum - cI;

end