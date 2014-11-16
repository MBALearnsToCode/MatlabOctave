function f = arrSubsetHighestDim(Arr, subset_vec)
   
   switch arrNumDims(Arr)
   
      case (0)
         f = Arr;
       
      case (1)
         f = Arr(subset_vec);
         
      case (2)
         f = Arr(:, subset_vec);
      
      case (3)
         f = Arr(:, :, subset_vec);
   
   endswitch
   
end