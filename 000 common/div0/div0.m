function f = div0(numerator_Arr, denominator_Arr)

   f = numerator_Arr ./ denominator_Arr;
   f(denominator_Arr == 0) = 0;

endfunction