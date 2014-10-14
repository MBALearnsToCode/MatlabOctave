function f = costFuncType_forTransformFuncType...
   (transformFuncType)

   switch (transformFuncType)
      case ('linear')
         f = 'SE';
      case ('logistic')
         f = 'CE-L';
      case ('softmax')
         f = 'CE-S';         
   endswitch
      
endfunction