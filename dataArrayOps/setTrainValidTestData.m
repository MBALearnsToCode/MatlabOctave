function f = setTrainValidTestData(dataArgs_list, ...
   trainBatchSize = 0, trainRandShuff = true);

   dataNumArgs = length(dataArgs_list);
   
   if (dataNumArgs <= 3)
      
      dataInput = dataArgs_list{1};
      dataTargetOutput = dataArgs_list{2};
      if (dataNumArgs == 3)
         proportionsTrainValid = dataArgs_list{3};
      else
         proportionsTrainValid = [];
      endif

      randShuff_vec = randperm(min(size(dataInput, 1), ...
         rows(dataTargetOutput)));
      dataInput = arrOpAcrossDim(dataInput, 'subset', ...
         randShuff_vec);
      dataTargetOutput = ...
         arrOpAcrossDim(dataTargetOutput, 'subset', ...
         randShuff_vec);
         
      dataInput_partitioned = partitionData(dataInput, ...
         proportionsTrainValid, trainBatchSize, false);
      dataTargetOutput_partitioned = ...
         partitionData(dataTargetOutput, ...
         proportionsTrainValid, trainBatchSize, false);
      
      batchSize = ...
         dataTargetOutput_partitioned.trainBatchSize;
      trainNumBatches = ...
         dataTargetOutput_partitioned.trainNumBatches;
      trainInputBatches_batchDim = ...
         dataInput_partitioned.trainBatchDim;
      trainTargetOutputBatches_batchDim = ...
         dataTargetOutput_partitioned.trainBatchDim;
      trainInput = dataInput_partitioned.train;
      trainTargetOutput = ...
         dataTargetOutput_partitioned.train;
      trainInput_batches = ...
         dataInput_partitioned.train_batches;
      trainTargetOutput_batches = ...
         dataTargetOutput_partitioned.train_batches;
      validInput = dataInput_partitioned.valid;
      validTargetOutput = ...
         dataTargetOutput_partitioned.valid;
      testInput = dataInput_partitioned.test;
      testTargetOutput = ...
         dataTargetOutput_partitioned.test;
          
   else      
   
      trainInput = dataArgs_list{1};
      trainTargetOutput = dataArgs_list{2};
      trainNumCases = min(size(trainInput, 1), ...
         rows(trainTargetOutput));
      if (trainRandShuff)
         randShuff_vec = randperm(trainNumCases);
         trainInput = arrOpAcrossDim(trainInput, ...
            'subset', randShuff_vec);
         trainTargetOutput = ...
            arrOpAcrossDim(trainTargetOutput, 'subset', ...
            randShuff_vec);
      endif
      if (trainBatchSize == 0)
         batchSize = trainNumCases;
      else
         batchSize = min(trainBatchSize, trainNumCases);
      endif
      trainNumBatches = floor(trainNumCases / batchSize);
      trainInput_batches = arrOpAcrossDim(trainInput, ...
         'split', batchSize);
      trainTargetOutput_batches = ...
         arrOpAcrossDim(trainTargetOutput, 'split', ...
         batchSize);
      trainInputBatches_batchDim = ...
         arrNumDims(trainInput_batches);
      trainTargetOutputBatches_batchDim = ...
         arrNumDims(trainTargetOutput_batches); 
 
      validInput = dataArgs_list{3};
      validTargetOutput = dataArgs_list{4};
      
      if (dataNumArgs == 6)
         testInput = dataArgs_list{5};
         testTargetOutput = dataArgs_list{6};
      else
         testInput = testTargetOutput = [];
      endif
     
   endif

   trainBatchDim = max(trainInputBatches_batchDim, ...
      trainTargetOutputBatches_batchDim);
   if (trainNumBatches > 1)
      if (trainInputBatches_batchDim < trainBatchDim)
         trainInput_batches = ...
            arrSetHighestDim(trainInput_batches, ...
            trainBatchDim);
      endif
      if (trainTargetOutputBatches_batchDim < trainBatchDim)
         trainTargetOutput_batches = ...
            arrSetHighestDim(trainTargetOutput_batches, ...
            trainBatchDim);
      endif
   endif

   f.trainBatchSize = batchSize;
   f.trainNumBatches = trainNumBatches;
   f.trainBatchDim = trainBatchDim;
   f.trainInput = trainInput;
   f.trainTargetOutput = trainTargetOutput;
   f.trainInput_batches = trainInput_batches;
   f.trainTargetOutput_batches = trainTargetOutput_batches;
   f.validInput = validInput;
   f.validTargetOutput = validTargetOutput;
   f.testInput = testInput;
   f.testTargetOutput = testTargetOutput;

end