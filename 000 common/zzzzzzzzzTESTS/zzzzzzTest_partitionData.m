fprintf('ORIGINAL DATA\n');
dataArr = reshape(1:370, 10, [])'

pausePressKey;
fprintf('\n \n \n');
fprintf('DEFAULT SPLIT 60:20:20, FULL TRAINING BATCH, ROW-WISE, UNSHUFFLED\n');
p = partitionData(dataArr, [], 0, false)
size(p.train)
[size(p.valid); size(p.test)]

pausePressKey;
fprintf('\n \n \n');
fprintf('DEFAULT SPLIT 60:20:20, FULL TRAINING BATCH, ROW-WISE, SHUFFLED\n');
p = partitionData(dataArr, [], 0)
size(p.train)
[size(p.valid); size(p.test)]

pausePressKey;
fprintf('\n \n \n');
fprintf('DEFAULT SPLIT 60:20:20, TRAINING BATCH SIZE = 6, ROW-WISE, SHUFFLED\n');
p = partitionData(dataArr, [], 6)
size(p.train)
[size(p.valid); size(p.test)]

pausePressKey;
fprintf('\n \n \n');
fprintf('SPLIT 50:[]:[], TRAINING BATCH SIZE = 5, ROW-WISE, SHUFFLED\n');
p = partitionData(dataArr, 0.5, 5)
size(p.train)
[size(p.valid); size(p.test)]

pausePressKey;
fprintf('\n \n \n');
fprintf('SPLIT 70:[]:[], TRAINING BATCH SIZE = 3, COLUMN-WISE, UNSHUFFLED\n');
p = partitionData(dataArr, 0.7, 3, false, 2)
size(p.train)
[size(p.valid); size(p.test)]