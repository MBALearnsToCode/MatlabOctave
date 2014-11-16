function f = convertText_toRegulFunc(nameOfFunc)

   switch (nameOfFunc)   
      case ('L1')
         f = @regulL1_Mat;      
      case ('L2')
         f = @regulL2_Mat;         
      case (const_MacKay_empBayes_str)
         f = @regulL2_Mat;
   endswitch
       
endfunction