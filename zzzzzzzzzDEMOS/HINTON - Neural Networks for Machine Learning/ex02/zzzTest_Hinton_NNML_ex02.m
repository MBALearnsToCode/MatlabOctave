function model = zzzTest_Hinton_NNML_ex02...
   (epochs = 1, nesterov = false)

   startTime = time;   

   % PARAMETERS
   % ----------
   trainBatchSize = 1e2;
   learningRate = 1e-1;
   momentum = 0.9;
   numEmbedNodes = 50;
   numHidNodes = 200;
   initBiasWeightSD = 1e-2;

   % PARAMETERS FOR TRACKING TRAINING PROGRESS
   % -----------------------------------------
   showCostTrain_every = 1e2;
   showCostValid_every = 1e3;

   % LOAD DATA
   % ---------
   [train_input, train_target, valid_input, valid_target, ...
     test_input, test_target, vocab] = ...
     load_data(trainBatchSize);
   vocabSize = length(vocab);
   trainInput = permute(train_input, [2 1 3]);
   %size(trainInput)
   trainTargetOutput = permute(train_target, [2 1 3]);
   %size(trainTargetOutput)
   validInput = valid_input';
   %size(validInput)
   validTargetOutput = valid_target';
   %size(validTargetOutput)
   validTargetOutput_Mat = convertClassifColVecToRowMat...
      (validTargetOutput, vocabSize);
   %size(validTargetOutput_Mat)
   testInput = test_input';
   %size(testInput)
   testTargetOutput = test_target';
   %size(testTargetOutput)
   testTargetOutput_Mat = convertClassifColVecToRowMat...
      (testTargetOutput, vocabSize);
   %size(testTargetOutput_Mat)   
   [trainBatchSize numWords numTrainBatches] = ...
      size(trainInput);

   % SET UP NEURAL NET
   % -----------------
   ffNN = ffNN_new(numWords, ...
      {[vocabSize numEmbedNodes] ...
      [(numWords * numEmbedNodes + 1) numHidNodes] ...
      [(numHidNodes + 1) vocabSize]}, ...
      {'embedClassIndices_inRealFeatures' ...
      'logistic' 'softmax'});    
   ffNN = ffNN_initParams(ffNN);
   ffNN_immedParamChangesMemory = ...
       ffNN_initParamChangesMemory(ffNN);
   
   warning('off');
   
   % TRAIN NEURAL NET
   % ----------------
   for (epoch = 1 : epochs)
      
  

      fprintf(1, 'EPOCH %d\n', epoch);
      costTrain = costThisChunk = count = 0;
       
      % LOOP OVER MINI-BATCHES
      % ----------------------
      for (b = 1 : numTrainBatches)
         trainInput_batch = ...
            trainInput(:, :, b);
         trainTargetOutput_batch = ...
            trainTargetOutput(:, :, b);
         trainTargetOutput_batch_Mat = ...
            convertClassifColVecToRowMat...
            (trainTargetOutput_batch, vocabSize);          
        
         if (mod(b, showCostValid_every) == 0)
                    
            [ffNN ffNN_immedParamChangesMemory ...
               trainCostsAvg_noRegul_bfrUpdates ...
               validCostsAvg_noRegul_aftUpdates] = ...
               ffNN_gradDesc_nesterovAccGrad_or_momentum...
               (ffNN, ffNN_immedParamChangesMemory, ...
               trainInput_batch, ...
               trainTargetOutput_batch_Mat, ...
               0, learningRate, momentum, 1, true, ...
               validInput, ...
               validTargetOutput_Mat, nesterov);
            
         else
         
            [ffNN ffNN_immedParamChangesMemory ...
               trainCostsAvg_noRegul_bfrUpdates] = ...
               ffNN_gradDesc_nesterovAccGrad_or_momentum...
               (ffNN, ffNN_immedParamChangesMemory, ...
               trainInput_batch, ...
               trainTargetOutput_batch_Mat, ...
               0, learningRate, momentum, 1, true, ...
               [], [], nesterov);
               
         endif
                 
         count++;
         costThisChunk += ...
            (trainCostsAvg_noRegul_bfrUpdates ...
            - costThisChunk) / count;
         costTrain += ...
            (trainCostsAvg_noRegul_bfrUpdates ...
            - costTrain) / b;
         fprintf(1, '\rBatch %d Train CE %.3f', b, costThisChunk);
         if (mod(b, showCostTrain_every) == 0)
            fprintf(1, '\n');
            costThisChunk = count = 0;
         endif
         fflush(1);   

         if (mod(b, showCostValid_every) == 0)
            fprintf(1, '\rRunning validation ...');
            fflush(1);
            fprintf(1, ' Validation CE %.3f\n', validCostsAvg_noRegul_aftUpdates);
            fflush(1);
         endif
         
      endfor
            
      fprintf(1, '\rAverage Training CE %.3f\n', costTrain);

   endfor

   fprintf(1, 'Finished Training.\n');
   fflush(1);
   fprintf(1, 'Final Training CE %.3f\n', costTrain);
   model.takeTime = ffNN.takeTime;
   % EVALUATE ON VALIDATION SET
   % --------------------------
   fprintf(1, '\rRunning validation ...');
   fflush(1);
   costValid = ffNN_fProp_bProp(validInput, ffNN, ...
      validTargetOutput_Mat, 0, false).costAvg_noRegul;
   fprintf(1, '\rFinal Validation CE %.3f\n', costValid);
   fflush(1);

   % EVALUATE ON TEST SET
   % --------------------
   fprintf(1, '\rRunning test ...');
   fflush(1);
   costTest = ffNN_fProp_bProp(testInput, ffNN, ...
      testTargetOutput_Mat, 0, false).costAvg_noRegul;
   fprintf(1, '\rFinal Test CE %.3f\n', costTest);
   fflush(1);

   %model.word_embedding_weights = embedWeights;
   %model.embed_to_hid_weights = embed_to_hid_weights;
   %model.hid_to_output_weights = hid_to_output_weights;
   %model.hid_bias = hid_bias;
   %model.output_bias = output_bias;
   %model.vocab = vocab;

   endTime = time;
   duration = endTime - startTime;
   fprintf(1, 'Training took %.2f seconds\n', duration);
   
end