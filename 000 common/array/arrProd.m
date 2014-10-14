function f = arrProd(Arr1, Arr2 = 1, numElimDims = 1)
   
   % OBTAIN ARRAYS' DIMENSION SIZES
   % ------------------------------
   dimSzs1 = arrDimSizes(Arr1);
   numDims1 = length(dimSzs1);
   dimSzs2 = arrDimSizes(Arr2);
   numDims2 = length(dimSzs2);

   % EXTEND ARR1'S ENDING SINGLETON DIMENSIONS
   % TO MATCH ARR2'S BEGINNING SINGLETON DIMENSIONS
   % (UP TO NO. OF ELIMINATING DIMENSIONS)
   % -----------------------------------------------
   numExtendedDims1 = 0;
   d = 1;

   while (numExtendedDims1 < numElimDims) ...
      && (d <= numDims2) && (dimSzs2(d) == 1)
      dimSzs1(end + 1) = 1;
      numExtendedDims1++;
      d++; 
   endwhile
   
   numDims1 = length(dimSzs1);      

   % EXTEND ARR2'S ENDING DENEGERATE DIMENSIONS
   % TO MAXIMISE DIMENSION MATCHINGS WITH
   % ARR1'S BEGINNING SINGLETON DIMENSIONS
   % ------------------------------------------   
   while (numDims2 < numDims1)
      dimSzs2(end + 1) = 1;
      numDims2++;
   endwhile

   % DETERMINE MAXIMAL FEASIBLE
   % NO. OF ELIMINATING DIMENSIONS
   % ----------------------------- 
   dimSzs1_reverse = fliplr(dimSzs1);
   numElimDims_maxFeas = 0;
   d = 1;
   minNumDims = min(numDims1, numDims2); 

   while (d <= minNumDims) ...
      && (dimSzs1_reverse(d) == dimSzs2(d))
      numElimDims_maxFeas++;
      d++;
   endwhile

   numElimDims_adj = ...
      min(numElimDims, numElimDims_maxFeas);

   % REPLICATE ARRAYS ACROSS NEW DIMENSIONS
   % AND PERMUTE ARR2 TO PRODUCE
   % DIMENSIONALLY-MATCHED ARRAYS
   % -------------------------------------- 
   repTimes1_vec = ...
      dimSzs2((numElimDims_adj + 1) : numDims2);
   repArr1 = ...
      arrRepAcrossNewDims(Arr1, numDims1, repTimes1_vec);
   repTimes2_vec = ...
      dimSzs1(1 : (numDims1 - numElimDims_adj));
   repArr2 = ...
      arrRepAcrossNewDims(Arr2, numDims2, repTimes2_vec);
   perm2_vec = [(numDims2 + 1) : ...
      (numDims2 + numDims1 - numElimDims_adj) ...
      fliplr(1 : numElimDims_adj) ...
      (numElimDims_adj + 1) : numDims2];
   repArr2_perm = arrPerm(repArr2, perm2_vec);

   % TAKE ELEMENT-WISE PRODUCT,
   % SUM ACROSS ELIMINATING DIMENSIONS
   % AND PERMUTE AWAY ELIMINATED DIMENSIONS
   % --------------------------------------
   repArrProd_elementWise = repArr1 .* repArr2_perm;
   sumDims_vec = ...
      (numDims1 - numElimDims_adj + 1) : numDims1;
   repArrProd_elementWise_sumAcrossElimDims = ...
      arrSumAcrossDims(repArrProd_elementWise, sumDims_vec);
   prodPerm_vec = [1 : (numDims1 - numElimDims_adj) ...
      (numDims1 + 1) : ...
      (numDims1 + numDims2 - numElimDims_adj) ...
      (numDims1 - numElimDims_adj + 1) : numDims1];
   f = arrPerm(repArrProd_elementWise_sumAcrossElimDims, ...
      prodPerm_vec);

end