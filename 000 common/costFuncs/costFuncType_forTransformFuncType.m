function f = costFuncType_forTransformFuncType...
   (transformFuncType)

   switch (transformFuncType)
      case ('linear')
         f = 'SE';
      case ('logistic')
         f = 'CE-L';
      case ('softmax')
         f = 'CE-S';
      case ('Embed Class Indices in Real Features')
         f = '';
   endswitch
      
endfunction