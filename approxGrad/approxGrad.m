function f = approxGrad(func, Arr, epsilon = 1e-6)

   f = zeros(size(Arr));
   for (e = 1 : numel(Arr))
      Arr_plus = Arr; Arr_plus(e) += epsilon;
      Arr_minus = Arr; Arr_minus(e) -= epsilon;
      f(e) = ...
         (func(Arr_plus) - func(Arr_minus)) / (2 * epsilon);      
   endfor

end