% DEMO_RPROP_1 IRprop- on MNIST-small dataset
%   This Demo train a Neural Network on the MNIST-small dataset
%

%   Copyright (c) 2011 Roberto Calandra
%   $Revision: 0.60 $



function Demo_Rprop_1(batch)

if nargin<1, batch=0; end

%% Load Data

% Load the MNIST-small dataset
load rob_mnist_small

% Shuffle data
[train_in ti]   = shuffledata(train_in);
train_out       = shuffledata(train_out,ti);
[test_in to]    = shuffledata(test_in);
test_out        = shuffledata(test_out,to);

% Convert labels to the internal class system used in the package
[nn train_out_c]  = RNN.lab2class(train_out);
[nn test_out_c]   = RNN.lab2class(test_out,nn);

clear ti to


%% Init Network

% Declare the structure of the network
ndim = size(train_in,2);
neurons = [ndim,300,200,nn.nlabels,1];

% Declare the Transfer function 
% (Optional: will override parameter in init_in)
nn.o.init_nn.tf = 'log-sigmoid'; % 'tan-sigmoid'

% Create and initialize the Network
nn = RNN.init_nn(neurons,nn);

% (Optional: will override parameter in opt_rprop)
if batch
    nn.o.opt_rprop.display      = 0;
    nn.o.opt_rprop.verbose      = 0;
else
    nn.o.opt_rprop.display      = 1;
    nn.o.opt_rprop.verbose      = 2;
end

% Maximum number of Iterations for the Training
% (Optional: will override parameter in opt_rprop)
nn.o.opt_rprop.MaxIter      = 30;

% Desired MSE for the Training
% (Optional: will override parameter in opt_rprop)
nn.o.opt_rprop.dmse         = 1.0e-3;


%% Train Network

% Train the network
% (As default IRprop- is used in opt_rprop)
% (Optional: test_in and test_out are not required, but allow to compute
% more statistics of the training process)
[nn1 error1] = RNN.opt_rprop(nn,train_in,train_out_c,test_in,test_out_c);

% Classify the test set
output_c = RNN.computenetwork(nn1,test_in);

% Convert from the internal class system back to labels
output = RNN.class2lab(nn,output_c);

% Compute statistics
stats = RNN.class_stat(output,test_out,10);


%% Evaluate Results

if batch
else

    fprintf('Test set accuracy: %f\n',stats.accuracy)
    
    % Plot the confusion matrix
    fprintf('Confusion Matrix\n')
    disp(stats.confusion)
    
end


end

