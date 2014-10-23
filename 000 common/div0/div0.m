function f = div0(numerator_Arr, denominator_Arr)

   warning ('off', 'Octave:divide-by-zero');
   f = numerator_Arr ./ denominator_Arr;
   f(denominator_Arr == 0) = 0;
   warning ('error', 'Octave:divide-by-zero');

endfunction