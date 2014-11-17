function f = ffNN_loadFile(loadFileName)

   f = load(loadFileName).ffNN_file;
   f.func_convertInput = str2func...
      (f.func_convertInput);
   for (l = 1 : f.numTransforms)
      transformFuncs = f.transformFuncs;
      f.transformFuncs{l} = convertText_toTransformFunc...
         (transformFuncs{l});
   endfor

endfunction