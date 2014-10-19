function m = updateLayer(rbm, layerToUpdate = 'vis', ...
   otherLayer_rowMat, sample = true)

   weights = rbm.weights;
   
   switch (layerToUpdate)
   
      case ('vis')
         transformFunc = rbm.transformFunc_fromHid_toVis;
         func_signal = transformFunc.func_signal;
         func_output = transformFunc.func_output_effDeriv;
         if (rbm.addBiasVis)
            weights = weights(:, 2 : end);
         endif
         signal = func_signal(otherLayer_rowMat, weights);
         s = rbm.visSoftmaxPartitionSize;
         if strcmp(transformFunc.funcType, 'softmax') && ...
            (s > 1)
            dimSizes = size(signal);                        
            numNodes = dimSizes(2);
            numPartitions = floor(numNodes / s);
            m = zeros([rows(signal) (numPartitions * s)]);
            for (p = 1 : numPartitions)
               partition_vec = ((p - 1) * s + 1) : (p * s);
               probs = func_output...
                  (signal(:, partition_vec), false).val;
               if (sample)   
                  m(:, partition_vec) = sampleSoftmax(probs);
               else
                  m(:, partition_vec) = probs;
               endif
            endfor
         else
            m = func_output(signal, false).val;
            if (sample)
               m = sampleBern(m);
            endif
         endif     
      
      case ('hid')
         transformFunc = rbm.transformFunc_fromHid_toVis;
         func_signal = transformFunc.func_signal;
         func_output = transformFunc.func_output_effDeriv;
         if (rbm.addBiasHid)
            weights = weights(2 : end, :);
         endif
         signal = func_signal(otherLayer_rowMat, weights');
         m = func_output(signal, false).val;  
         if (sample)
            m = sampleBern(m);
         endif
         
   endswitch

endfunction