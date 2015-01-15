function [polyDeg hypoRelDiff] = ...
   detectPolyDeg(x_colVec, y_colVec, ...
   thresholdPrecision = 1e-3)

   polyDeg = 0;
   X = [];
   m = length(y_colVec);
   while (polyDeg < m)
      X = [X (x_colVec .^ polyDeg)];
      w = linearRegWeights_analytic(X, y_colVec, false);
      [eqTest hypoRelDiff] = ...
         equalTest(X * w, y_colVec, thresholdPrecision);
      if (eqTest) || (polyDeg == m - 1)
         return;
      endif
      polyDeg++;
   endwhile

end