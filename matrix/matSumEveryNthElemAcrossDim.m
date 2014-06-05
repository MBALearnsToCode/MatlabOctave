function f = matSumEveryNthElemAcrossDim(Mat, n, ...
   acrossDimNum = 1)
   
   N = size(Mat, acrossDimNum);
   numParts = ceil(N / n);
   f = 0;
   Mat_toSum = Mat;
   
   for (j = 1 : numParts)
   
      switch (acrossDimNum)
         
         case (1)
            f += Mat_toSum(1 : n, :);
            Mat_toSum = Mat_toSum((n + 1) : end, :);
           
         case (2)
            f += Mat_toSum(:, 1 : n);
            Mat_toSum = Mat_toSum(:, (n + 1) : end);
     
      endswitch
      
   endfor
   
end