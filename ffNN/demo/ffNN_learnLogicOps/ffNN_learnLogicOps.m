% This script demonstrates the ability of a 1-to-2-layer
% Forward-Feeding Neural Network (FFNN) to learn single logical
% operations NOT, AND, OR and XOR and complicated combinations
% of such operations 

function [ffNN X y]= ffNN_learnLogicOps(trainMethod = 'gradDesc')

fprintf('\n');
numOperands = input('No. of Operands = ');
fprintf('\n');

specify = input('Would You Like to Specify Logical Operators? (0 / 1) ');
if (specify)
   logicOps = [@and, ...
      input(cstrcat('   Specify ', num2str(numOperands - 1), ...
      ' AND / OR Logical Operators (@and / @or, separated by commas in {}): '))];
   for (j = 1 : (numOperands - length(logicOps)))
      logicOps{end + 1} = @and;
   endfor
   notSwitches = input(cstrcat('   Specify ', ...
       num2str(numOperands), ...
      ' NOT Switches OFF / ON (0 / 1 in []): '));
   for (j = 1 : (numOperands - length(notSwitches)))
      notSwitches(end + 1) = false;
   endfor
else
   for (j = 1 : numOperands)
      logicOps{j} = randElem({@and, @or});
      notSwitches(j) = randElem([false true]);  
   endfor   
endif
for (j = 1 : numOperands)
   switch logicOps{j}
      case (@and)
         logicOp_txt = ' and ';         
      case (@or)
         logicOp_txt = ' or ';         
      case (@xor)
         logicOp_txt = ' xor ';         
   endswitch
   if (j == 1)
      formula_txt = '(X1)';
   else
      formula_txt = cstrcat('(', formula_txt, ...
         logicOp_txt, strcat('X', mat2str(j)), ')');  
   endif
   if notSwitches(j)
      formula_txt = strcat('not', formula_txt);
   endif
endfor

fprintf('\nLogic Formula to Learn:\n   Y = %s\n\n', formula_txt);
m = 2 ^ numOperands;
X = false([m numOperands]);
y = false([m 1]);
for (i = 1 : m)
   binStr = dec2bin(i - 1);
   for (k = 1 : (numOperands - length(binStr)))
      binStr = strcat('0', binStr);
   endfor
   for (j = 1 : numOperands)
      X(i, j) = str2num(binStr(j));
      if (j == 1)
         y(i) = X(i, j);
      else
         y(i) = logicOps{j}(y(i), X(i, j));
      endif
      if notSwitches(j)
         y(i) = not(y(i));
      endif
   endfor
   fprintf('\rGenerating Data... %i / %i Cases (%g%%)         ', ...
      i, m, 100 * i / m);
endfor
fprintf('\n\n');

fprintf('1-or-2-Layer Forward-Feeding Neural Network (FFNN):\n');
numHidNodes = input('   No. of Hidden-Layer Nodes = ');
if (numHidNodes)
   ffNN = class_ffNN(numOperands, [numHidNodes 1], ...
      {}, false);      
else
   ffNN = class_ffNN(numOperands, [], {}, false);
endif
batchSize_log2 = min(input('   Mini-Batch Size = 2 ^ '), ...
   numOperands);
numTrainEpochs = input('   No. of Training Epochs = ');
learningRate = input('   Learning Rate = ');

switch (trainMethod)
   
   case ('gradDesc')
      ffNN = train_gradDesc(ffNN, ...
         dataArgs_list = {X y X y X y}, ...
targetOutputs_areClassIndcsColVecs_ofNumClasses = false, ...
         trainNumEpochs = numTrainEpochs, ...
         trainBatchSize = (2 ^ batchSize_log2), ...
         trainRandShuff = (batchSize_log2 < numOperands), ...
         trainCostApproxChunk_numBatches = ...
            (2 ^ (numOperands - batchSize_log2)), ...
         validCostCalcInterval_numChunks = 1, ...
         learningRate_init = learningRate, ...
         momentumRate_init = 9e-1, ...
         nesterovAccGrad = true, ...
         weightRegulArgs_list = {{'L2'} [0]});
         
    case ('rmsProp')
       ffNN = train_rmsProp(ffNN, ...
          dataArgs_list = {X y X y X y}, ...
targetOutputs_areClassIndcsColVecs_ofNumClasses = false, ...
          trainNumEpochs = numTrainEpochs, ...
          trainBatchSize = (2 ^ batchSize_log2), ...   
          trainRandShuff = (batchSize_log2 < numOperands), ...
          trainCostApproxChunk_numBatches = ...
             (2 ^ (numOperands - batchSize_log2)), ...
          validCostCalcInterval_numChunks = 1, ...
          stepRate_init = learningRate, ...          
          decayRate_init = 9e-1, momentumRate_init = 9e-1, ...    
          nesterovAccGrad = true, ...
          weightRegulArgs_list = {{'L2'} [0]});
          
endswitch
      
y_pred = predict(ffNN, X);
% predictions_vs_correctResults = [X y y_pred]
numAccurate = sum(y_pred == y);
fprintf('PREDICTIVE ACCURACY: %i / %i Cases (%g%%)\n\n', ...
   numAccurate, m, 100 * numAccurate / m);
   
endfunction