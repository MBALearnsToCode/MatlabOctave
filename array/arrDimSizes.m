% ARRDIMSIZES is a variation of the built-in SIZE function
% that returns the dimension sizes of an array excluding
% trailing singleton dimensions.
%
% Specifically, a scalar number's arrDimSizes is [],
% not [1 1], and a M-long column vector's arrDimSizes
% is just M, not [M 1]. 



function f = arrDimSizes(Arr)

   f = size(Arr);
   while (~isempty(f)) && (f(end) == 1)
      f = f(1 : (end - 1));
   endwhile

end