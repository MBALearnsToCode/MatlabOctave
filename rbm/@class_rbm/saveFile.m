function saveFile(rbm, saveFileName)

   rbm_file = rbm;
   
   rbm_file.transformFunc_fromHid_toVis = ...
      convertTransformFunc_toText...
      (rbm_file.transformFunc_fromHid_toVis);
   rbm_file.transformFunc_fromVis_toHid = ...
      convertTransformFunc_toText...
      (rbm_file.transformFunc_fromVis_toHid);
      
   save(saveFileName, 'rbm_file');

endfunction