function f = ffNN_initParamChangesMemory(ffNN)
   
   for (l = 1 : ffNN.numLayers)
      f{l} = zeros(size(ffNN.params{l}));
   endfor
   
end