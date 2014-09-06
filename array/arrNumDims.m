% ARRNUMDIMS is a variation of the in-built NDIMS function
% that returns the number of dimensions of an array, excluding
% any trailing singleton dimensions.
%
% Specifically, a scalar number's ARRNUMDIMS is 0 and a column
% vector's is 1, while in both cases the NDIMS is 2.



function f = arrNumDims(Arr)

   f = length(arrDimSizes(Arr));

end