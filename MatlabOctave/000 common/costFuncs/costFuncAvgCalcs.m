function [costFuncAvg weightedTargetArr] = ...
   costFuncAvgCalcs(hypoArr, targetArrs_args, ...
   targetArrs_areClassIndcsColVecs_ofNumClasses = false, ...
   classSkewnesses = [1], ...
   costFuncType = 'CE-L', returnGrad = false, casesDim = 1)

   switch (costFuncType)
      case ('SE')
         funcCostAvg = @costFuncAvg_sqErr;
         costFuncType_isCrossEntropy = false;
      case ('CE-L')
         funcCostAvg = @costFuncAvg_crossEntropy_logistic;
         costFuncType_isCrossEntropy = true;
      case ('CE-S')
         funcCostAvg = @costFuncAvg_crossEntropy_softmax;
         costFuncType_isCrossEntropy = true;
   endswitch
   
   if iscell(targetArrs_args)
      multipleTargets = true;
      targetArrs_list = targetArrs_args{1};
      l1 = length(targetArrs_list);
      targetWeightages = targetArrs_args{2};
      if isempty(targetWeightages)
         targetWeightages = ones([1 l1]) / l1;
      endif
      l2 = length(targetWeightages);      
      if (l1 < l2)
         numTargets = l1;
         targetWeightages = targetWeightages(1 : numTargets);
      elseif (l1 > l2)
         numTargets = l2;
         targetArrs_list = targetArrs_list(1 : numTargets);
      else 
         numTargets = l1;
      endif
      targetWeightages = targetWeightages ...
         / sum(targetWeightages);    
   else      
      multipleTargets = false;
      targetArr = targetArrs_args;
   endif   
   
   if (targetArrs_areClassIndcsColVecs_ofNumClasses)
      if (multipleTargets)
         func = @(colVec) convertClassIndcsColVec_toRowMat...
            (colVec, ...
            targetArrs_areClassIndcsColVecs_ofNumClasses);
         targetArrs_list = cellfun(func, targetArrs_list, ...
            'UniformOutput', false);
      else
         targetArr = convertClassIndcsColVec_toRowMat...
            (targetArr, ...
            targetArrs_areClassIndcsColVecs_ofNumClasses);
      endif
   endif
   
   if (multipleTargets)
      weightedTargetArr = zeros(size(targetArrs_list{1}));
      for (t = 1 : numTargets)
         weightedTargetArr += targetWeightages(t) ...
            * targetArrs_list{t};
      endfor
   else
      weightedTargetArr = targetArr;
   endif
   
   if (returnGrad)      
      calcs = funcCostAvg...
         (hypoArr, weightedTargetArr, classSkewnesses, ...
         true, casesDim);
      if (costFuncType_isCrossEntropy)
         costFuncAvg.accuracyAvg = calcs.accuracyAvg;
      endif
      costFuncAvg.val = calcs.val;
      costFuncAvg.grad = calcs.grad;
   else     
      calcs = funcCostAvg...
         (hypoArr, weightedTargetArr, classSkewnesses, ...
         false, casesDim);
      if (costFuncType_isCrossEntropy)
         costFuncAvg.accuracyAvg = calcs.accuracyAvg;
      endif
      costFuncAvg.val = calcs.val;
   endif
   
endfunction