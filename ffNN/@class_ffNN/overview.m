function overview(ffNN)

   fprintf('\nOVERVIEW OF FORWARD-FEEDING NEURAL NETWORK:\n')
   
   fprintf('   Admissible Input Dimensions: %s per Case\n', ...
      mat2str(ffNN.inputDimSizes_perCase));
   
   fprintf('   No. of Transformations: %i\n', ...
      ffNN.numTransforms);
   
   fprintf('   Transformation Functions:');
   disp(cellfun(@(transformFunc) ...
      strcat(upper(transformFunc.funcType), ' with' , ...
      sprintf(' %i', transformFunc.addBias), ' bias'), ...
      ffNN.transformFuncs, 'UniformOutput', false));
   
   fprintf('   Weight Dimensions:');      
   disp(printArrDimSizes_chain(ffNN.weights));
   
   fprintf('   No. of Weights: %i\n', ffNN.numWeights);
   
   fprintf('   Cost Function: %s\n\n', ffNN.costFuncType);
      
endfunction