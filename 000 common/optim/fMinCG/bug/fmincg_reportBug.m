% This script shows a BUG with the FMINCG function

% load House Prices data
data = load('housePrices.txt');
X = data(:, 1 : 2);   
y = data(:, 3);
fprintf('\nHouse Prices dataset loaded\n');

fprintf('\nRegression coefficients calculated by different methods:\n\n');
% calculate analytic regression coefficients
fprintf('   Analytic solution:\n');
X_bias = [ones([rows(y), 1]), X];
w_analytic = pinv(X_bias' * X_bias) * (X_bias' * y)

% set fMin function handle and options
funcHandle = @(w) funcHandle_sqErr(w, X, y);
fMin_options = optimset('GradObj', 'on', 'MaxIter', 3000);

% fMinUnc solution
fprintf('   FMinUnc solution:\n');
w_fminunc = fminunc(funcHandle, zeros([3, 1]), fMin_options)

% fMinCG solution
fprintf('   FMinCG soltion (WRONG!!!):\n')
w_fmincg = fmincg(funcHandle, zeros([3, 1]), fMin_options)