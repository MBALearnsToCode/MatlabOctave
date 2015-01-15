function plot2D_decisionBoundary...
   (binClasses_colVec, inputFeatures_rowMat_2Cols, ...
   func_decision_vsZero, numPoints_linSpace = 30, neg = 0)

   plot2D_binClasses(binClasses_colVec, ...
      inputFeatures_rowMat_2Cols, neg);
   hold on;
   
   x1 = inputFeatures_rowMat_2Cols(:, 1);
   x2 = inputFeatures_rowMat_2Cols(:, 2);
   l1 = l2 = numPoints_linSpace;
   u1 = linspace(min(x1), max(x1), l1);   
   u2 = linspace(min(x2), max(x2), l2);
   [mesh1 mesh2] = meshgrid(u1, u2);
   
   vals = zeros([l2 l1]);    
   for (i = 1 : l1)      
      vals(:, i) = func_decision_vsZero...
         ([mesh1(:, i) mesh2(:, i)]);
   endfor    

   contour(u1, u2, vals, [0 0], 'LineColor', 'red');

   hold off;

endfunction