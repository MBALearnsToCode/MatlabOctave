function [Mat_norm, mu, rng] = ...
   normalizeMeanRange_rowMat_colWise(Mat)

   mu = mean(Mat);
   Mat_norm = bsxfun(@minus, Mat, mu);
   rng = range(Mat_norm);
   Mat_norm = bsxfun(@rdivide, Mat_norm, rng);

end