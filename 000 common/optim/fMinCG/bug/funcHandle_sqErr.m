function [f g] = funcHandle_sqErr(w, X, y)

   m = rows(y);
   X = [ones([m, 1]), X];
   err = X * w - y;
   f = (err' * err) / (2 * m);
   g = (X' * err) / m;

endfunction