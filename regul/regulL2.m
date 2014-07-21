function f = regulL2(Arr)

   f.val = Arr .* Arr / 2;
   f.grad = Arr;

end