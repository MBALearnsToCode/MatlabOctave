function plot2D_binClasses(binClasses_colVec, ...
   inputFeatures_rowMat_2Cols, neg = 0)

   figure;
   hold on;

   posCases = find(binClasses_colVec == 1);
   negCases = find(binClasses_colVec == neg);

   plot(inputFeatures_rowMat_2Cols(posCases, 1), ...
      inputFeatures_rowMat_2Cols(posCases, 2), ...
      'k+','LineWidth', 3, 'Color', 'blue', ...
      'MarkerSize', 9);      
   plot(inputFeatures_rowMat_2Cols(negCases, 1), ...
      inputFeatures_rowMat_2Cols(negCases, 2), ...
      'ko', 'MarkerFaceColor', 'yellow', 'MarkerSize', 9);
      
   hold off;

endfunction