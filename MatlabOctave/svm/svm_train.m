function f = svm_train...
   (input_rowMat, targetOuput_colVec, 
   softMarginConst = 1e3, ...   
   funcKern = @linearKernMat_rowMat, ...
   skip0orCAlphasAfter = 27, ...
   maxNumPasses_woSignifChanges = 1, ...
   svmType = 'L1', precisionTolerance = 1e-3, zero = 1e-9)
   
   t0 = time;
fprintf('\n\nTraining SVM by Sequential Minimal Optimization (SMO)...\n');
fprintf('   (skipping alphas = 0 or C\n      after %i consecutive unchanged optims w/ unbounded alphas)\n', ...
skip0orCAlphasAfter);
   
   m = rows(input_rowMat);
   y = convertBinClassIndcs(targetOuput_colVec, [0 2], -1);
   c = zeros(m, 1); % c = y .* alpha
   numPasses = 0;
   numPasses_woSignifChanges = 0;

   alphas_0_bw_C = false(m, 3);   
   numsTimesAlphasStill0 = numsTimesAlphasStillC = ...
      zeros(m, 1);
   potentialUnboundedSupVecs = true(1, m);

   % Random shuffle
   fprintf('\r   Shuffling data...');
   shuff = randperm(m);
   X = input_rowMat(shuff, :);
   y = y(shuff, :);
   
   % Pre-Compute Kernel Matrix (okay when dataset is small)   
   fprintf('\r   Pre-Computing Input Kernel Matrix...');
   K = funcKern(X, X);

   while (numPasses_woSignifChanges ...
      < maxNumPasses_woSignifChanges)
      
      numPasses++;
      signifChanges = false;

      potentialUnboundedSupVecIndcs = ...
         (1 : m)(logical(potentialUnboundedSupVecs));

      for (i = potentialUnboundedSupVecIndcs)

         if ~potentialUnboundedSupVecs(i)
            continue;
         endif
         
         if alphas_0_bw_C(i, 2)

            for (j = potentialUnboundedSupVecIndcs)
 
               if (j == i) || ~potentialUnboundedSupVecs(j)
                  continue;
               endif
            
               cI_old = c(i);
               [c(i) c(j)] = svm_pairSMO(c, i, j, ...
                   y(i), y(j), softMarginConst, K);
               if (abs(c(i) - cI_old) ...
                  > precisionTolerance)
                  signifChanges = true;
               endif

               alphaI = max(y(i) * c(i), 0);
               alphaJ = max(y(j) * c(j), 0);
fprintf('\r   %is: Pass #%i (%i unbounded SVs): alpha%i= %.3f, alpha%i= %.3f      ', ...
                  [(time - t0) numPasses ...
                  sum(potentialUnboundedSupVecs) ...
                  i alphaI j alphaJ]);
            
               if (alphaI > zero) && ...
                  (alphaI < softMarginConst - zero)                  
                  
                  if consider0(alphaJ, zero)

                     alphas_0_bw_C(j, :) = ...
                        [true false false];
                     numsTimesAlphasStill0(j)++;
                     numsTimesAlphasStillC(j) = 0;
                     if (numsTimesAlphasStill0(j) ...
                        > skip0orCAlphasAfter)
                        potentialUnboundedSupVecs(j) = false;
                     endif

                  elseif (abs(alphaJ - softMarginConst) ...
                     < zero)

                     alphas_0_bw_C(j, :) = ...
                        [false false true];
                     numsTimesAlphasStill0(j) = 0;
                     numsTimesAlphasStillC(j)++;
                     if (numsTimesAlphasStillC(j) ...
                        > skip0orCAlphasAfter)
                        potentialUnboundedSupVecs(j) = false;       
                     endif

                  else
                     
                     alphas_0_bw_C(j, :) = ...
                        [false true false];
                     numsTimesAlphasStill0(j) = ...
                        numsTimesAlphasStillC(j) = 0;  
                  
                  endif

               elseif (alphaJ > zero) && ...
                  (alphaJ < softMarginConst - zero)

                  alphas_0_bw_C(j, :) = [false true false];
                  numsTimesAlphasStill0(j) = ...
                     numsTimesAlphasStillC(j) = 0;  

                  if consider0(alphaI, zero)

                     alphas_0_bw_C(i, :) = [true false false];  
                     numsTimesAlphasStill0(i)++;
                     numsTimesAlphasStillC(i) = 0;
                     if (numsTimesAlphasStill0(i) ...
                        > skip0orCAlphasAfter)
                        potentialUnboundedSupVecs(i) = ...
                           false;
                        break;
                     endif
                    
                  else

                     alphas_0_bw_C(i, :) = [false false true];
                     numsTimesAlphasStill0(i) = 0;
                     numsTimesAlphasStillC(i)++;
                     if (numsTimesAlphasStillC(i) ...
                        > skip0orCAlphasAfter)
                        potentialUnboundedSupVecs(i) = ...
                           false;
                        break;
                     endif

                  endif
           
               endif
               
            endfor

         else

            do 
               j = randElem(potentialUnboundedSupVecIndcs);
            until (j ~=i) ...
               && (y(i) * c(i) + y(j) * c(j) ...
               < 2 * softMarginConst - zero)

            cI_old = c(i);
            [c(i) c(j)] = svm_pairSMO(c, i, j, ...
                y(i), y(j), softMarginConst, K);
            if (abs(c(i) - cI_old) ...
               < precisionTolerance)
               signifChanges = true;
            endif 

            alphaI = max(y(i) * c(i), 0);
            alphaJ = max(y(j) * c(j), 0);
fprintf('\r   %is: Pass #%i (%i unbounded SVs): alpha%i= %.3f, alpha%i= %.3f      ', ...
               [(time - t0) numPasses ...
               sum(potentialUnboundedSupVecs) ...
               i alphaI j alphaJ]);

            if (alphaI > zero) && ...
               (alphaI < softMarginConst - zero)
                  
               alphas_0_bw_C(i, :) = [false true false];
               numsTimesAlphasStill0(i) = ...
                  numsTimesAlphasStillC(i) = 0;
                
               if consider0(alphaJ, zero)
               
                  alphas_0_bw_C(j, :) = [true false false];
                  numsTimesAlphasStill0(j)++;
                  numsTimesAlphasStillC(j) = 0;
                  if (numsTimesAlphasStill0(j) ...
                     > skip0orCAlphasAfter)
                     potentialUnboundedSupVecs(j) = false;
                  endif

               elseif (abs(alphaJ - softMarginConst) ...
                  < zero)
                  alphas_0_bw_C(j, :) = [false false true];
                  numsTimesAlphasStill0(j) = 0;
                  numsTimesAlphasStillC(j)++;
                  if (numsTimesAlphasStillC(j) ...
                     > skip0orCAlphasAfter)
                     potentialUnboundedSupVecs(j) = false;
                  endif

               else

                  alphas_0_bw_C(j, :) = [false true false];
                  numsTimesAlphasStillC(j) = ...
                     numsTimesAlphasStillC(j) = 0;

               endif
               
            elseif (alphaJ > zero) && ...
               (alphaJ < softMarginConst - zero)         
               
               alphas_0_bw_C(j, :) = [false true false];
               numsTimesAlphasStill0(j) = ...
                  numsTimesAlphasStillC(j) = 0;  

               if consider0(alphaI, zero)

                  alphas_0_bw_C(i, :) = [true false false];  
                  numsTimesAlphasStill0(i)++;
                  numsTimesAlphasStillC(i) = 0;
                  if (numsTimesAlphasStill0(i) ...
                     > skip0orCAlphasAfter)
                     potentialUnboundedSupVecs(i) = false;
                  endif
                    
               else

                  alphas_0_bw_C(i, :) = [false false true];
                  numsTimesAlphasStill0(i) = 0;
                  numsTimesAlphasStillC(i)++;
                  if (numsTimesAlphasStillC(i) ...
                     > skip0orCAlphasAfter)
                     potentialUnboundedSupVecs(i) = false;
                  endif

               endif
                       
            endif

         endif

      endfor

      if (signifChanges)
         numPasses_woSignifChanges = 0;
      else
         numPasses_woSignifChanges++;
      endif

   endwhile
   
   fprintf('\n   Iterations finished!.|.\n\n');
   
   alphas = y .* c;
   supVecIndcs = alphas > zero;
   
   f.softMarginConst = softMarginConst;
   f.funcKern = funcKern;
   f.input_supVecs = input_supVecs = ...
      X(logical(supVecIndcs), :);
   f.targetOutput_supVecs = targetOutput_supVecs = ...
      y(logical(supVecIndcs));
   f.alphas_supVecs = alphas_supVecs = ...
      alphas(logical(supVecIndcs));
      
   if (funcKern == @linearKernMat_rowMat)
      f.weights = input_supVecs' ...
         * (alphas_supVecs .* targetOutput_supVecs);
   endif
      
   % Compute Bias term
   % (!!! ASSUMING there are UNBOUNDED Support Vectors)
   K_supVecs = K(logical(supVecIndcs), logical(supVecIndcs));
   unboundedSupVecIndcs = alphas_supVecs ...
      < softMarginConst - zero;
   targetOutput_unboundedSupVecs = ...
      targetOutput_supVecs(logical(unboundedSupVecIndcs));
   alphas_unboundedSupVecs = ...
      alphas_supVecs(logical(unboundedSupVecIndcs));
   numUnboundedSupVecs = sum(unboundedSupVecIndcs);
   
   f.bias = (sum(targetOutput_unboundedSupVecs) ...
      - arrSumAllDims(bsxfun(@times, ...
      alphas_supVecs .* targetOutput_supVecs, ...
      K_supVecs(:, logical(unboundedSupVecIndcs))))) ...
      / numUnboundedSupVecs;

end