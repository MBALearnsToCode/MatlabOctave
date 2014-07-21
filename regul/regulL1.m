function f = regulL1(Arr)

   f.val = arrSumAllDims(abs(Arr));
   f.grad = sign(Arr);

end