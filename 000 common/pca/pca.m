function [U S] = pca(rowMat)

   covMat = rowMat' * rowMat / rows(rowMat);
   [U S V] = svd(covMat);

end