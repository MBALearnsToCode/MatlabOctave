function m = cd(rbm, sampleVis_rowMat, chainLength = 1)
   
   hid = updateLayer(rbm, 'hid', sampleVis_rowMat, false);
   posParticle = expectHidVis(rbm, hid, visSample_rowMat);
   
   hid = sampleBern(hid);   
   for (t = 1 : chainLength)      
      vis = updateLayer(rbm, 'vis', hid, true);
      hid = updateLayer(rbm, 'hid', vis, t < chainLength);
   endfor   
   negParticle = expectHidVis(rbm, hid, vis);

   m = posParticle - negParticle;
   
endfunction