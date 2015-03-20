function [weightGrad_est reconstructVis] = ...
   contrastiveDivergence(rbm, sampleVis_rowMat, ...
   chainLength = 1, sampleLastHid = false, ...
   useRandSource = false, randSource_Mat = [])
   
   transformFunc = rbm.transformFunc_fromHid_toVis;
   s = rbm.visSoftmaxPartitionSize;
   if strcmp(transformFunc.funcType, 'softmax') && ...
      (s > 1)
      dimSizes = size(sampleVis_rowMat);                        
      numNodes = dimSizes(2);
      numPartitions = floor(numNodes / s);
      vis = zeros([rows(sampleVis_rowMat) ...
         (numPartitions * s)]);
      for (p = 1 : numPartitions)
         partition_vec = ((p - 1) * s + 1) : (p * s);
         vis(:, partition_vec) = sampleSoftmax...
            (vis, useRandSource, randSource_Mat);
      endfor
   else
      vis = sampleBern(sampleVis_rowMat, ...
         useRandSource, randSource_Mat);
   endif   
   hid = updateLayer(rbm, 'hid', vis, true, ...
      useRandSource, randSource_Mat);
   posParticle = expectHidVis(rbm, hid, vis);   
   
   for (t = 1 : chainLength)      
      reconstructVis = updateLayer(rbm, 'vis', hid, true, ...
         useRandSource, randSource_Mat);
      hid = updateLayer(rbm, 'hid', reconstructVis, ...
         (t < chainLength) || sampleLastHid, ...
         useRandSource, randSource_Mat);
   endfor   
   negParticle = expectHidVis(rbm, hid, reconstructVis);

   weightGrad_est = posParticle - negParticle;
   
endfunction