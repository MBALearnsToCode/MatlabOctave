function plot2D_decisionBoundary...
   (binClasses_colVec, inputFeatures_rowMat_2Cols, ...
   func_decision_vsZero, neg = 0)

   plot2D_binClasses(binClasses_colVec, ...
      inputFeatures_rowMat_2Cols, neg);
   hold on;
   
   x1 = inputFeatures_rowMat_2Cols(:, 1);
   x2 = inputFeatures_rowMat_2Cols(:, 2);
   r1 = range(x1) / 6;
   u1 = linspace(min(x1) - r1, max(x1) + r1);   
   l1 = length(u1);
   r2 = range(x2) / 6;
   u2 = linspace(min(x2) - r2, max(x2) + r2);
   l2 = length(u2);
   [mesh1 mesh2] = meshgrid(u1, u2);
   
   vals = zeros([l2 l1]);    
   for (i = 1 : l1)      
      vals(:, i) = func_decision_vsZero...
         ([mesh1(:, i) mesh2(:, i)]);
   endfor    

   contour(u1, u2, vals, [0 0], 'LineColor', 'red');

   hold off;

endfunction