function numSuccesses = ...
   zzzTest_perceptron(numDemos = 1, maxNumIters = 1000)



numSuccesses = 0;

for demo = 1:numDemos

fprintf('\rTest Run no.: %i', demo);

% constants
% ---------
maxNumInputFeatures = 6;
maxNumOutputFeatures = 6;
maxNumExamples = 8;



% (cosmetics)
% -----------
%fprintf('\n');
%fprintf('\n');
%fprintf('\n');
%fprintf('PERCEPTRON DEMO no. %i\n',demo);
%fprintf('\n');



% initialise
% ----------
NX = unidrnd(maxNumInputFeatures);
NY = unidrnd(maxNumOutputFeatures);
M = unidrnd(maxNumExamples);

%fprintf('INITIALISING...\n');
%fprintf('No. of Input Features = %i\n', NX);
%fprintf('No. of Output Features = %i\n', NY);
%fprintf('No. of Examples = %i\n', M);

%fprintf('\n');

X = rand(M, NX)-rand(M, NX);
Theta = rand(NX, NY)-rand(NX, NY);
Y = binThreshFunc(X * Theta);

%fprintf('Input Matrix =\n');
%X
%fprintf('Target Output Matrix =\n');
%Y



% learn weights iteratively
% -------------------------
[Theta, iters] = perceptronLearn(X, Y, maxNumIters);

if (iters <= maxNumIters)
   numSuccesses++;
  % fprintf('Learning SUCCESS in %i iterations :)\n', iters);
  % fprintf('\n');
  % fprintf('Learned Weights =\n');
  % Theta
else
   fprintf('Learning FAILURE in %i iterations :(\n', maxNumIters);
endif



endfor



% report no. of successes
% -----------------------
%fprintf('\n');
%fprintf('\n');
%fprintf('\n');

fprintf('\nRESULT: %i/%i Perceptron Demos Successful\n', [numSuccesses, numDemos]);

%fprintf('\n');



end





