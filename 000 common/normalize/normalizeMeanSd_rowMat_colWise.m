function [Mat_norm, mu, sigma] = ...
   normalizeMeanSd_rowMat_colWise(Mat)

   mu = mean(Mat);
   Mat_norm = bsxfun(@minus, Mat, mu);
   sigma = std(Mat_norm);
   Mat_norm = bsxfun(@rdivide, Mat_norm, sigma);

end