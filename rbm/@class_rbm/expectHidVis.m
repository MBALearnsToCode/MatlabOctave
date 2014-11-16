function m = expectHidVis(rbm, hid_rowMat, vis_rowMat)
   
   addBiasHid = rbm.addBiasHid;
   addBiasVis = rbm.addBiasVis;
   
   m = addBiasElems(hid_rowMat, addBiasHid)' ...
      * addBiasElems(vis_rowMat, addBiasVis) ...
      / rows(hid_rowMat);
   
   if (addBiasHid * addBiasVis)
      m(1, 1) = 0;
   endif
   
endfunction