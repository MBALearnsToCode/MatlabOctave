function f = partitionData...
   (dataArr, proportionsTrainValid = [0.6 0.2], ...
   trainBatchSize = 0, randShuff = true, casesDim = 1)

   if (randShuff)     
      dataArr_shuff = ...
         arrOpAcrossDim(dataArr, 'shuffle', [], casesDim);
   else      
      dataArr_shuff = dataArr;
   endif
   
   switch (length(proportionsTrainValid))
   
      case (0)
         trainProportion = 0.6;
         validProportion = 0.2;
      
      case (1)
         trainProportion = min(proportionsTrainValid, 1.0);
         validProportion = (1 - trainProportion) / 2;
      
      case (2)
         trainProportion = ...
            min(proportionsTrainValid(1), 1.0);
         validProportion = ...
            min(proportionsTrainValid(2), ...
            1 - trainProportion);
   
   endswitch

   testProportion = 1 - trainProportion - validProportion;
   
   dimSzs = arrDimSizes(dataArr_shuff);
   numDims = length(dimSzs);
   numCases = dimSzs(casesDim);
   numTrainCases = floor(trainProportion * numCases);
 
   if (trainBatchSize == 0)   
      batchSize = numTrainCases;
   else
      batchSize = min(trainBatchSize, numTrainCases);
   endif
   
   f.trainBatchSize = batchSize;
   f.trainNumBatches = numBatches = ...
      floor(numTrainCases / batchSize);
   numTrainCases = numBatches * batchSize;
   f.trainBatchDim = numDims + 1;   
   f.train = arrOpAcrossDim(dataArr_shuff, 'subset', ...
      1 : numTrainCases, casesDim);  
   
   f.train_batches = arrOpAcrossDim(f.train, 'split', ...
      batchSize, casesDim);
   
   numRemainingCases = numCases - numTrainCases;
   
   if (validProportion > 0)
      if (testProportion > 0)      
         numValidCases = floor(validProportion ...
            / (validProportion + testProportion) ...
            * numRemainingCases);
      else
         numValidCases = numRemainingCases;
      endif
   else
      numValidCases = 0;
   endif
   
   if (testProportion > 0)
      numTestCases = numRemainingCases - numValidCases;
   else
      numTestCases = 0;
   endif
   
   if (numValidCases > 0)
      f.valid = arrOpAcrossDim(dataArr_shuff, 'subset', ...
         numTrainCases + (1 : numValidCases), casesDim);
   else
      f.valid = [];
   endif

   if (numTestCases > 0)
      f.test = arrOpAcrossDim(dataArr_shuff, 'subset', ...
         numTrainCases + numValidCases ...
         + (1 : numTestCases), casesDim);
   else
      f.test = [];
   endif
   
end