function f = zzzTest_ffNN_vs_linReg_wRegul(numRuns = 1)

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

      fprintf('\rTest Run no. : %i', r);

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
         + regulParam * sum(sum(W .^ 2)) / (2 * m);
      linRegModel{r}.activGrad = err / m;
      linRegModel{r}.biasWeightGrad = bX' * err / m ...
         + regulParam * [zeros([aB nO]); W] / m;

      % NEURAL NETWORK
      % --------------
      ffNN = ffNN_new(nI, {[(nI + aB) nO]}, ...
         {funcLinear_inputRowMat_n_biasWeightMat(aB)}, ...
         false);       
      ffNN.params{2} = bW;
      ffNN = ffNN_fProp_bProp(X, ffNN, Y, regulParam);

      ffNNModel{r}.hypoOutput = ffNN.hypoOutput;
      ffNNModel{r}.costAvg = ffNN.costAvg_wRegul;
      ffNNModel{r}.activGrad = ffNN.activGrads{2};
      ffNNModel{r}.biasWeightGrad = ffNN.paramGrads{2};

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

   fprintf('\n\n%i successes out of %i tests\n\n', succs, numRuns);

end