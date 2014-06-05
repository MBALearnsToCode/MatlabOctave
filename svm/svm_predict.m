function f = svm_predict(input_rowMat, svm)

   f = sign(bsxfun(@plus, ...
      svm.funcKern(input_rowMat, svm.input_supVecs) ...
      * svm.alphas_supVecs, svm.bias));
      
end