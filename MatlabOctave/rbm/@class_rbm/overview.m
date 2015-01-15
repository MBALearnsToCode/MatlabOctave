function overview(rbm)

   fprintf('\nOVERVIEW OF RESTRICTED BOLTZMANN MACHINE (RBM):\n')
   
   fprintf('   No. of Hidden Units: %i, +%i Always-ON Bias\n', ...
      rbm.numHid, rbm.addBiasHid);
   
   fprintf('   No. of Visible Units: %i, +%i Always-ON Bias\n', ...
      rbm.numVis, rbm.addBiasVis);   
   
   transformFunc = rbm.transformFunc_fromHid_toVis;
   funcType = transformFunc.funcType;
   visSoftmaxPartitionSize = rbm.visSoftmaxPartitionSize;
   fprintf('   Hidden-to-Visible Transformation Function: %s\n', ...
      strcat(upper(funcType), ' with' , ...
      sprintf(' %i', transformFunc.addBias), ' bias'));
   if (strcmp(funcType, 'softmax')) && ...
      (visSoftmaxPartitionSize > 1)
      fprintf('      Visible Layer''s Softmax Partition Size: %i\n', ...
         visSoftmaxPartitionSize);
   endif
   
   transformFunc = rbm.transformFunc_fromVis_toHid;   
   fprintf('   Visible-to-Hidden Transformation Function: %s\n', ...
      strcat(upper(transformFunc.funcType), ' with' , ...
      sprintf(' %i', transformFunc.addBias), ' bias'));
      
   fprintf('   Weight Dimensions: %s\n', ...
      mat2str(rbm.weightDimSizes));
   
   fprintf('   No. of Weights: %i\n\n', rbm.numWeights);   
   
endfunction