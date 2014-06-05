function f = splitData...
   (dataArr, trainProportion = 0.6, trainBatchSize = 0, ...
   casesDim = 1, randShuff = true)

   if (randShuff)     
      dataArr_shuff = ...
         arrOpAcrossDim(dataArr, 'shuffle', 0, casesDim);
   else      
      dataArr_shuff = dataArr;
   endif
   
   dimSzs = size(dataArr_shuff);
   numDims = length(dimSzs);
   numCases = dimSzs(casesDim);
   numTrainCases = floor(trainProportion * numCases);
 
   if (trainBatchSize == 0)   
      batchSize = numTrainCases;
   else
      batchSize = min(trainBatchSize, numTrainCases);
   endif

   numBatches = floor(numTrainCases / batchSize);
   numTrainCases = numBatches * batchSize;
   f.trainBatchDim = numDims + 1;   
   f.train = arrOpAcrossDim(dataArr_shuff, 'subset', ...
      1 : numTrainCases, casesDim);
   f.train = arrOpAcrossDim(f.train, 'split', ...
      batchSize, casesDim);
   
   numValidCases = floor((numCases - numTrainCases) / 2);  
   f.valid = arrOpAcrossDim(dataArr_shuff, 'subset', ...
      numTrainCases + (1 : numValidCases), casesDim);

   numTestCases = numCases - numTrainCases - numValidCases;
   f.test = arrOpAcrossDim(dataArr_shuff, 'subset', ...
      numTrainCases + numValidCases + (1 : numTestCases), ...
      casesDim);

end