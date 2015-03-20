trainI = datI = reshape(1 : 370, 10, [])'
trainO = datO = (1 : 37)'
trainO_2 = datO_2 = [(1 : 37)' (10 * (1 : 37)')]
validI = reshape(371 : 400, 10, [])'
validO = (38 : 40)'
testI = reshape(401 : 420, 10, [])'
testO = (41 : 42)'

pausePressKey;
fprintf('\n \n \n');
fprintf('DEFAULT SPLIT 60:20:20\n');
s = setTrainValidTestData({datI datO})

pausePressKey;
fprintf('\n \n \n');
fprintf('DEFAULT SPLIT 60:20:20, BATCH SIZE = 6\n');
s = setTrainValidTestData({datI datO}, 6)

pausePressKey;
fprintf('\n \n \n');
fprintf('DEFAULT SPLIT 60:20:20, BATCH SIZE = 6, OUTPUT MUTLIDIMENSIONAL\n');
s = setTrainValidTestData({datI datO_2}, 6)

pausePressKey;
fprintf('\n \n \n');
fprintf('SPLIT 50:[]:[], BATCH SIZE = 5\n');
s = setTrainValidTestData({trainI trainO 0.5}, 5)

pausePressKey;
fprintf('\n \n \n');
fprintf('SPLIT 50:[]:[], BATCH SIZE = 5, OUTPUT MUTLIDIMENSIONAL\n');
s = setTrainValidTestData({trainI trainO_2 0.5}, 5)