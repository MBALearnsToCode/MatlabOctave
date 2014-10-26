function [X y] = load_bicepCurlQuality

   data = load('bicepCurlQuality.mat').data;   
   y = data(:, 1);
   X = data(:, 2 : end);

endfunction