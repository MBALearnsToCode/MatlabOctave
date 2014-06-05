function f = predictClass_rowMat...
   (classifProbtyMat, returnIndices = false)

   switch (returnIndices)

      case (false)
         f = classifProbtyMat == ...
            repmat(max(classifProbtyMat, [], 2), ...
            [1 columns(classifProbtyMat)]);
     
      case (true)
         [dummy f] = max(classifProbtyMat, [], 2);
 
   endswitch     

end