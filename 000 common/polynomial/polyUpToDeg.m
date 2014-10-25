function [poly_rowMat powerMat numTerms] = ...
   polyUpToDeg(rowMat, deg = 1)
   
   n = columns(rowMat);
   numTerms = (deg + 1) ^ n;
   powerMat = zeros([(numTerms - 1) n]);
   for (i = 1 : numTerms - 1)
      term{i} = dec2base(i, deg + 1, n);
      for (j = 1 : n)
         powerMat(i, j) = str2num(term{i}(j));
      endfor
   endfor
   powerMat = powerMat(sum(powerMat, 2) <= deg, :);
   [~, ascOrder] = sort(sum(powerMat, 2));
   powerMat = powerMat(ascOrder, fliplr(1 : end));   
   numTerms = rows(powerMat);
   poly_rowMat = ones([rows(rowMat) numTerms]);   
   for (j = 1 : numTerms)
      poly_rowMat(:, j) = prod(bsxfun...
         (@power, rowMat, powerMat(j, :)), 2);
   endfor
   
endfunction