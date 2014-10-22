function [rbm_updated ...
   trainGoodnessAvg_exclWeightPenalty_approx ...
   validGoodnessAvg_exclWeightPenalty ...
   trainGoodnessesAvg_exclWeightPenalty_approx ...
   validGoodnessesAvg_exclWeightPenalty ...
   immedWeightChangesMemory_updated] = ...
   train_gradAsc(rbm, dataArgs_list, ...   
   trainNumsEpochs = 1, cd_chainLengths = 1, ...   
   trainBatchSize = false, trainRandShuff = true, ...
   trainGoodnessApproxChunk_numBatches = 1, ...
   validGoodnessCalcInterval_numChunks = 1, ...
   learningRate_init = 1e-1, momentumRate_init = 9e-1, ...
   nesterovAccGrad = true, weightRegulArgs_list = {'L2' 0}, ...
   bestStop = true, immedWeightChangesMemory_init = [], ...
   plotLearningCurves = true, batchDim = 3, ...
   saveEvery_numMins = 3, saveFileName = 'rbm_trained.mat', ...
   useRandSource = false, randSource_Mat = [])
   % zzzBORED = 'Z' - waiting for Octave's TIMER functionality
   
   rbm_updated = rbm;
   addBiasHid = rbm_updated.addBiasHid;
   addBiasVis = rbm_updated.addBiasVis;   
   weightDimSizes = rbm.weightDimSizes;
   if isempty(immedWeightChangesMemory_init)
      immedWeightChangesMemory_updated = ...
         zeros(weightDimSizes);
   else
      immedWeightChangesMemory_updated = ...
         immedWeightChangesMemory_init;
   endif
   trainGoodnessAvg_exclWeightPenalty_approx = ...
      validGoodnessAvg_exclWeightPenalty = 0;   
   trainGoodnessesAvg_exclWeightPenalty_approx = ...
      validGoodnessesAvg_exclWeightPenalty = [];
   
   trainData = dataArgs_list{1};
   if (length(dataArgs_list) > 1)
      validData = dataArgs_list{2};
   else
      validData = [];
   endif
   if (trainRandShuff)
      trainData = arrOpAcrossDim(trainData, 'shuffle');
   endif
   if (trainBatchSize)
      trainData_batches = arrOpAcrossDim...
         (trainData, 'split', trainBatchSize);
   else
      trainBatchSize = size(trainData, 1);
      trainData_batches = trainData;
   endif
   trainBatchDim = max(batchDim, ...
      arrNumDims(trainData_batches));
   trainNumBatches = size(trainData_batches, trainBatchDim);   

   valid_provided = ~isempty(validData);
   validProvided_n_bestStop = valid_provided && bestStop;
   if (valid_provided)
      validBatchDim = max(batchDim, arrNumDims(validData));
   endif
   if (validProvided_n_bestStop)
      rbm_best = rbm_updated;
      validGoodnessAvg_exclWeightPenalty_best = -Inf;
      toSaveBest = false;
   endif
   
   learningRate = learningRate_init;
   momentumRate = momentumRate_init;
       
   trainGoodnessAvg_exclWeightPenalty_currChunk = ...      
      chunk = chunk_inEpoch = batch_inChunk = 0;
   
   validGoodnessCalcInterval_numBatches = ...
      validGoodnessCalcInterval_numChunks ...
      * trainGoodnessApproxChunk_numBatches;

   l = length(trainNumsEpochs);   
   for (i = (length(cd_chainLengths) + 1) : l)
      cd_chainLengths(i) = cd_chainLengths(i - 1);
   endfor   
   trainNumEpochs = sum(trainNumsEpochs);
   cd_chainLengths_expanded = [];   
   for (i = 1 : l)
      cd_chainLengths_expanded...
         ((end + 1) : (end + trainNumsEpochs(i))) = ...
         cd_chainLengths(i);
   endfor
   
   saveFileName_upper = upper(saveFileName);
   
   overview(rbm_updated);      
fprintf('TRAIN RESTRICTED BOLTZMANN MACHINE (RBM) (METHOD: GRADIENT ASCENT):\n\n'); 
   fprintf('   DATA SETS:\n');
   fprintf('      Training: %i cases\n', size(trainData, 1));
   if (valid_provided)
      fprintf('      Validation: %i cases\n', ...
         size(validData, 1));      
   endif  
   
   fprintf('\n   TRAINING SETTINGS:\n');   
   fprintf('      Training Epochs: %s\n', ...
      mat2str(trainNumsEpochs));
   fprintf('         w/ Constrastive Divergence Markov Chain Lengths: %s\n', ...
      mat2str(cd_chainLengths));
fprintf('      Training Batches per Epoch: %i batches of %i', ...
      trainNumBatches, trainBatchSize);
   if (trainRandShuff)
      fprintf(', shuffled in each epoch\n')
   else
      fprintf('\n');
   endif
   fprintf('      Learning Rate: %g\n', learningRate);
   if (momentumRate)
      fprintf('      Momentum: %g', momentumRate);
      if (nesterovAccGrad)
fprintf(',   applying Nesterov Accelerated Gradient (NAG)\n');
      else
         fprintf('\n');
      endif
   endif

   weightRegulFunc = weightRegulArgs_list{1};
   weightRegulParam = weightRegulArgs_list{2};
   fprintf('      Weight Penalty Method: %s,   Weight Penalty Term: %g\n', ...
      weightRegulFunc, weightRegulParam);   
   weightRegulFunc = convertText_toRegulFunc(weightRegulFunc);
   
   if (bestStop)
fprintf('      Model Selection by Best Validation Performance\n');
   endif
   
   fprintf('      Saving Results in %s on Working Directory every %i Minutes\n', ...
      saveFileName_upper, saveEvery_numMins);
      
   fprintf('\n');
   
   fprintf('   TRAINING PROGRESS:\n');
% fprintf(cstrcat('      (pre-terminate by "', zzzBORED, '" key stroke)\n'));
fprintf('      Training Avg Cost (excl Weight Penalty) approx''d w/ each chunk of %i batches\n',
      trainGoodnessApproxChunk_numBatches);
fprintf('      Validation Avg Cost (excl Weight Penalty) updated every %i batches\n', ...
      validGoodnessCalcInterval_numBatches);
   
   lastSaveTime = trainStartTime = time;
   
   for (epoch = 1 : trainNumEpochs)
      
      if (trainRandShuff) && (trainNumBatches > 1) && ...
         (epoch > 1)               
         trainData = arrOpAcrossDim(trainData, 'shuffle');
         trainData_batches = arrOpAcrossDim...
            (trainData, 'split', trainBatchSize);         
      endif
      
      for (batch = 1 : trainNumBatches)
         
         if (trainNumBatches > 1)
            trainData_batch = arrSubsetHighestDim...
              (trainData_batches, batch);            
         else
            trainData_batch = trainData_batches;
         endif
         
         trainGoodnessAvg_exclWeightPenalty_currBatch = ...
            goodnessAvg(rbm_updated, [], trainData_batch, ...
            trainBatchDim);
            
         rbm_temp = rbm_updated;
         if (momentumRate) && (nesterovAccGrad)            
            rbm_temp.weights += momentumRate ...
               * immedWeightChangesMemory_updated;
         endif
         cd_chainLength = cd_chainLengths_expanded(epoch);
         weightGrads = cd(rbm_temp, trainData_batch, ...
            cd_chainLength, false, ...
            useRandSource, randSource_Mat);
         if (weightRegulParam)
            weightGrads -= weightRegulParam ...
               * weightRegulFunc(rbm_temp.weights, ...
               [addBiasHid addBiasVis], true).grad;
         endif
            
         if (momentumRate)
            rbm_updated.weights += ...
               immedWeightChangesMemory_updated = ...               
               momentumRate ...
               * immedWeightChangesMemory_updated ...
               + learningRate * weightGrads;
         else
            rbm_updated.weights += ...
               immedWeightChangesMemory_updated = ...               
               learningRate * weightGrads;
         endif
         
         batch_inChunk++;         
         trainGoodnessAvg_exclWeightPenalty_currChunk += ...
            (trainGoodnessAvg_exclWeightPenalty_currBatch ...
            - trainGoodnessAvg_exclWeightPenalty_currChunk) ...
            / batch_inChunk;
         
         if (batch_inChunk == ...
            trainGoodnessApproxChunk_numBatches) || ...
            (batch == trainNumBatches)
                        
            chunk_inEpoch++; chunk++;
      trainGoodnessesAvg_exclWeightPenalty_approx(chunk) = ...
               trainGoodnessAvg_exclWeightPenalty_currChunk;
               
            if (valid_provided && ((mod(batch, ...
            validGoodnessCalcInterval_numBatches) == 0) || ...
               (batch == trainNumBatches)))
            
               validGoodnessAvg_exclWeightPenalty = ...
            validGoodnessesAvg_exclWeightPenalty(chunk) = ...
                  goodnessAvg(rbm_updated, [], validData, ...
                  validBatchDim);
                              
               if (bestStop && ...
                  (validGoodnessAvg_exclWeightPenalty ...
                  > validGoodnessAvg_exclWeightPenalty_best))
                  rbm_best = rbm_updated;
                  validGoodnessAvg_exclWeightPenalty_best = ...
                     validGoodnessAvg_exclWeightPenalty;                  
                  toSaveBest = true;
               endif
            
            else
            
               validGoodnessesAvg_exclWeightPenalty...
                  (chunk) = NA;
               
            endif
            
            if (time > lastSaveTime + saveEvery_numMins * 60)
               if (validProvided_n_bestStop)
                  if (toSaveBest)
                     saveFile(rbm_updated, saveFileName);
                     lastSaveTime = time;
                     toSaveBest = false;
                  endif
               else
                  saveFile(rbm_updated, saveFileName);
                  lastSaveTime = time;
               endif               
            endif            
            
            trainCurrTime = time;
            trainElapsedTime_numMins = ...
               (trainCurrTime - trainStartTime) / 60;
fprintf('\r      Epoch %i Batch %i (CD-%i): TRAIN %.3g, VALID %.3g, elapsed %.3gm      ', ...
               epoch, batch, cd_chainLength, ...
            trainGoodnessAvg_exclWeightPenalty_currChunk, ...              
               validGoodnessAvg_exclWeightPenalty, ...
               trainElapsedTime_numMins);
            
            if (plotLearningCurves)
               rbm_plotLearningCurves...
            (trainGoodnessAvg_exclWeightPenalty_currChunk, ...                  
               trainGoodnessesAvg_exclWeightPenalty_approx, ...   
                  validGoodnessAvg_exclWeightPenalty, ...                  
                  validGoodnessesAvg_exclWeightPenalty, ...  
                  chunk, ...
                  trainGoodnessApproxChunk_numBatches, ...
                  trainBatchSize, cd_chainLength, ...
                  trainElapsedTime_numMins);
            endif
               
            trainCostAvg_exclWeightPenalty_currChunk = ...
               trainAccuracyAvg_currChunk = batch_inChunk = 0;  
 
            if (batch == trainNumBatches)         
               chunk_inEpoch = 0;
            endif
 
         endif
         
      endfor
   
   endfor

fprintf('\n\n   RESULTS:   Training Finished w/ Following Avg Goodnesses (excl Weight Penalty):\n');

   trainGoodnessAvg_exclWeightPenalty_approx = ...
      trainGoodnessesAvg_exclWeightPenalty_approx(end);
   fprintf('      Training (approx''d by last chunk): %.3g\n', ...
      trainGoodnessAvg_exclWeightPenalty_approx);
      
   if (valid_provided)
      if (bestStop)
         rbm_updated = rbm_best;
         validGoodnessAvg_exclWeightPenalty = ...
            validGoodnessAvg_exclWeightPenalty_best;
      endif
      fprintf('      Validation: %.3g\n', ...
         validGoodnessAvg_exclWeightPenalty);
   endif

   fprintf('\n');
   
   saveFile(rbm_updated, saveFileName);
   
endfunction