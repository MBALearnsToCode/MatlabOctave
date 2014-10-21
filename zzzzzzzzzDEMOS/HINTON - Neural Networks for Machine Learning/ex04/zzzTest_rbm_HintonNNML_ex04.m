a4_init;
rbm = class_rbm(100, 256, 'logisticNoBias', 'logisticNoBias', ...
   1, true, false);
rbm.weights = test_rbm_w;

fprintf('QUESTION 2:\n');
vis = data_1_case';
hid = updateLayer(rbm, 'hid', vis, false, ...
   true, randomness_source);
describe_matrix(hid);
vis = data_10_cases';
hid = updateLayer(rbm, 'hid', vis, false, ...
   true, randomness_source);
describe_matrix(hid);
vis = data_37_cases';
hid = updateLayer(rbm, 'hid', vis, false, ...
   true, randomness_source);
describe_matrix(hid);
fprintf('\n');

fprintf('QUESTION 3:\n');
hid = test_hidden_state_1_case';
vis = updateLayer(rbm, 'vis', hid, false, ...
   true, randomness_source);
describe_matrix(vis);
hid = test_hidden_state_10_cases';
vis = updateLayer(rbm, 'vis', hid, false, ...
   true, randomness_source);
describe_matrix(vis);
hid = test_hidden_state_37_cases';
vis = updateLayer(rbm, 'vis', hid, false, ...
   true, randomness_source);
describe_matrix(vis);
fprintf('\n');

fprintf('QUESTION 4:\n');
hid = test_hidden_state_1_case';
vis = data_1_case';
g = goodnessAvg(rbm, hid, vis)
hid = test_hidden_state_10_cases';
vis = data_10_cases';
g = goodnessAvg(rbm, hid, vis)
hid = test_hidden_state_37_cases';
vis = data_37_cases';
g = goodnessAvg(rbm, hid, vis)
fprintf('\n');

fprintf('QUESTION 6:\n');
vis = data_1_case';
weightGrad = cd(rbm, vis, 1, true, true, randomness_source);
describe_matrix(weightGrad);
vis = data_10_cases';
weightGrad = cd(rbm, vis, 1, true, true, randomness_source);
describe_matrix(weightGrad);
vis = data_37_cases';
weightGrad = cd(rbm, vis, 1, true, true, randomness_source);
describe_matrix(weightGrad);
fprintf('\n');

fprintf('QUESTION 7:\n');
vis = data_1_case';
weightGrad = cd(rbm, vis, 1, false, true, randomness_source);
describe_matrix(weightGrad);
vis = data_10_cases';
weightGrad = cd(rbm, vis, 1, false, true, randomness_source);
describe_matrix(weightGrad);
vis = data_37_cases';
weightGrad = cd(rbm, vis, 1, false, true, randomness_source);
describe_matrix(weightGrad);
fprintf('\n');

rbm_trained = train_gradAsc(rbm, ...
   {data_37_cases', data_10_cases'}, ...
   [300 300 300], [1 3 6], false, false, 1, 1, ...
   0.1, 0.9, true);