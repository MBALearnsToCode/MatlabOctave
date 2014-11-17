function saveFile(ffNN, saveFileName)

   ffNN_file = ffNN;
   ffNN_file.func_convertInput = func2str...
      ffNN_file.func_convertInput;
   for (l = 1 : ffNN_file.numTransforms)
      transformFunc = ffNN_file.transformFuncs{l};
      ffNN_file.transformFuncs{l} = ...
         convertTransformFunc_toText(transformFunc);
   endfor
   save(saveFileName, 'ffNN_file');

endfunction