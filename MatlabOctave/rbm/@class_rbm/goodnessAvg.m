function m = goodnessAvg(rbm, hid_batches = [], vis_batches, ...
   batchDim = 3)

   hid_notGiven = isempty(hid_batches);
   
   if (hid_notGiven)
      numBatches = size(vis_batches, batchDim);
   else
      numBatches = min(size(hid_batches, batchDim), ...
         size(vis_batches, batchDim));
   endif
   
   if (numBatches == 1)   
      if (hid_notGiven)
         hid_batches = updateLayer(rbm, 'hid', vis_batches, ...
            false);
      endif   
      m = trace...
         ((addBiasElems(hid_batches, rbm.addBiasHid) ...
         * rbm.weights) ...
         * addBiasElems(vis_batches, rbm.addBiasVis)')...
         / rows(hid_batches);
   else
      m = 0;
      for (b = 1 : numBatches)
         vis_batch = arrSubsetHighestDim(vis_batches, b);
         if (hid_notGiven)
            hid_batch = updateLayer(rbm, 'hid', vis_batch, ...
               false);
         else
            hid_batch = arrSubsetHighestDim(hid_batches, b);
         endif
         m += ((trace...
            ((addBiasElems(hid_batch, rbm.addBiasHid) ...
            * rbm.weights) ...
            * addBiasElems(vis_batch, rbm.addBiasVis)')...
            / rows(hid_batch)) - m) / b;
      endfor
   endif
         
endfunction