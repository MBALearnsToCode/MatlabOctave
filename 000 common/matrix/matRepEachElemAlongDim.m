function f = matRepEachElemAlongDim(Mat, numTimes, ...
   alongDimNum = 1)
   
   switch (alongDimNum)
      case (1)
         rowMat = Mat;
      case (2)
         rowMat = Mat'; 
   endswitch
   
   [m n] = size(rowMat);
   
   f = zeros([m (n * numTimes)]);
   
   for (i = 1 : m)
      f(i, :) = repelems(rowMat(i, :), ...
         [1 : n; numTimes * ones([1 n])]);
   endfor
   
   if (alongDimNum == 2)
      f = f';
   endif   

end