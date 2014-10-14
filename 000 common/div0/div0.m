function f = div0(numerator_Arr, denominator_Arr)

   f = zeros(size(denominator_Arr));
   for i = 1 : numel(denominator_Arr)
      denominatorElem = denominator_Arr(i);
      if (denominatorElem)
         f(i) = numerator_Arr(i) / denominatorElem;
      endif
   endfor

end