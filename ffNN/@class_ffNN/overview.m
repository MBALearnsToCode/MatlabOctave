function overview(ffNN)

   fprintf('\nOVERVIEW OF FORWARD-FEEDING NEURAL NETWORK:\n')
   
   fprintf('\n   Admissible Input Dimensions: %s per Case\n', ...
      mat2str(ffNN.inputDimSizes_perCase));
   
   fprintf('\n   No. of Transformations: %i\n', ...
      ffNN.numTransforms);
   
   fprintf('\n   Transformation Functions:');
   disp(cellfun(@(transformFunc) ...
      strcat(upper(transformFunc.funcType), ' with' , ...
      sprintf(' %i', transformFunc.addBias), ' bias'), ...
      ffNN.transformFuncs, 'UniformOutput', false));
   
   fprintf('\n   Weight Dimensions:');      
   disp(printArrDimSizes_chain(ffNN.weights));
   
   fprintf('\n   No. of Weights: %i\n', ffNN.numWeights);
   
   fprintf('\n   Cost Function: %s\n\n', ffNN.costFuncType);
      
end