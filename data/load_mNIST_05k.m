function [dataInput dataTargetOutput ...
   imgHeight imgWidth] = load_mNIST_05k

   [dataInput dataTargetOutput] = load('mNIST_05k.mat');
   imgHeight = imgWidth = 20;

endfunction