function f = quadraticFunc(input_Arr, ...
   coeff2 = 1, coeff1 = 0, coeff0 = 0)
   
   f = coeff2 * (input_Arr .* input_Arr) ...
      + coeff1 * input_Arr + coeff0;

end