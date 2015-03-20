function f = zzzTest_ffNN_vs_linReg(numRuns = 1)

   % PARAMETERS
   % ----------
   maxNumCases = 9;
   maxNumInputs = 9;
   maxNumOutputs = 9;
   inputMagnOrder = 1e1;
   weightMagnOrder = 1e1;
   outputMagnOrder = 1e2;

   succs = 0; fails = [];

   for (r = 1 : numRuns)

      fprintf('\rTest #%i', r);

      regulParam = randElem(const_regulParams_10);

      m = tests{r}.m = unidrnd(maxNumCases);
      aB = tests{r}.aB = rand > 0.5;
      nI = tests{r}.nI = unidrnd(maxNumInputs);
      nO = tests{r}.nO = unidrnd(maxNumOutputs);
   
      % VARIABLES
      % ---------
      X = tests{r}.X = ...
        randUnif([m nI], inputMagnOrder);
      bX = tests{r}.bX = [ones([m aB]) X];

      b = tests{r}.b = ...
         randUnif([aB nO], weightMagnOrder);
      W = tests{r}.W = ...
         randUnif([nI nO], weightMagnOrder);
      bW = tests{r}.bW = [b; W];

      Y = tests{r}.Y = ...
         randUnif([m nO], outputMagnOrder);

      % LINEAR REGRESSION
      % -----------------
      H = linRegModel{r}.hypoOutput = bX * bW;
      err = H - Y;
      linRegModel{r}.costAvg = ...
         sum(sum((err .^ 2))) / (2 * m) ...
         + regulParam * sum(sum(W .^ 2)) / 2;
      linRegModel{r}.activGrad = err / m;
      linRegModel{r}.biasWeightGrad = bX' * err / m ...
         + regulParam * [zeros([aB nO]); W];

      % NEURAL NETWORK
      % --------------
      ffNN = class_ffNN(nI, {[(nI + aB) nO]}, ...
         {linear_transformFuncHandles(aB)}, false, false);
      ffNN.weights{1} = bW;      
      [weightGrads, ~, costAvg_inclWeightPenalty, ...
         hypoOutput] = fProp_bProp(ffNN, X, Y, false, ...
         {{'L2'} regulParam});

      ffNNModel{r}.hypoOutput = hypoOutput;
      ffNNModel{r}.costAvg = costAvg_inclWeightPenalty;
      ffNNModel{r}.biasWeightGrad = weightGrads{1};

      % COMPARE MODELS
      % --------------
      if equalTest(ffNNModel{r}.hypoOutput, ...
            linRegModel{r}.hypoOutput) && ...
         equalTest(ffNNModel{r}.costAvg, ...
            linRegModel{r}.costAvg) && ...
         equalTest(ffNNModel{r}.biasWeightGrad, ...
            linRegModel{r}.biasWeightGrad)
  
         succs++;
       
      else
          
         fails = [fails r];
      
      endif

   endfor

   f.tests = tests;
   f.linRegModel = linRegModel;
   f.ffNNModel = ffNNModel;
   f.fails = fails;

   fprintf('\n%i Successes / %i Tests\n\n', succs, numRuns);

end