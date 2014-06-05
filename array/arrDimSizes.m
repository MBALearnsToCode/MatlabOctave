function f = arrDimSizes(Arr)

   f = size(Arr);
   while (~isempty(f)) && (f(end) == 1)
      f = f(1 : (end - 1));
   endwhile

end