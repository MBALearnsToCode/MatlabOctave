fresh;

% zzzTest_ffNN_gradChk
% --------------------
fprintf('TESTING: zzzTest_ffNN_gradChk\n');
zzzTest_ffNN_gradChk(input('numRuns = '));
fprintf('\n');

% zzzTest_ffNN_vs_linReg
% ----------------------
fprintf('TESTING: zzzTest_ffNN_vs_linReg\n');
zzzTest_ffNN_vs_linReg(input('numRuns = '));
fprintf('\n');

% zzzTest_ffNN_vs_logReg
% ----------------------
fprintf('TESTING: zzzTest_ffNN_vs_logReg\n');
zzzTest_ffNN_vs_logReg(input('numRuns = '));
fprintf('\n');

% zzzTest_ffNN_vs_softmReg
% ------------------------
fprintf('TESTING: zzzTest_ffNN_vs_softmReg\n');
zzzTest_ffNN_vs_softmReg(input('numRuns = '));
fprintf('\n');

% NG Machine Learning: Ex01
% -------------------------
fprintf('TESTING: NG Machine Learning: Ex01 (LINEAR REGRESSION)\n');
if input('run? (1/0) = ')   
   zzzTest_Ng_ML_ex01;
endif
fprintf('\n');

% NG Machine Learning: Ex02
% -------------------------
fprintf('TESTING: NG Machine Learning: Ex02 (LOGISTIC REGRESSION)\n');
if input('run? (1/0) = ')
   zzzTest_Ng_ML_ex02;
endif
fprintf('\n');

% zzzTest_evalClassif
% -------------------
fprintf('TESTING: zzzzzzTest_evalClassif\n');
if input('run? (1/0) = ')
   zzzzzzTest_evalClassif;
endif
fprintf('\n');

% zzzTest_evalClassif
% -------------------
fprintf('TESTING: zzzzzzTest_partitionData\n');
if input('run? (1/0) = ')
   zzzzzzTest_partitionData;
endif
fprintf('\n');

% zzzTest_setTrainValidTestData
% -----------------------------
fprintf('TESTING: zzzzzzTest_setTrainValidTestData\n');
if input('run? (1/0) = ')
   zzzzzzTest_setTrainValidTestData;
endif
fprintf('\n');

% zzzTest_perceptron
% ------------------
fprintf('TESTING: zzzTest_perceptron\n');
zzzTest_perceptron(input('numRuns = '));
fprintf('\n');

% zzzTest_arrProd
% ---------------
fprintf('TESTING: zzzTest_arrProd\n');
zzzTest_arrProd(input('numRuns = '));
fprintf('\n');







% NG Machine Learning: Ex03
% -------------------------
fprintf('TESTING: NG Machine Learning: Ex03\n');
if input('run? (1/0) = ')
   cd 'D:\Cloud\Box Sync\GitHub\MBALearnsToCode\MatlabOctave\zzzzzzzzzDEMOS\NG - Machine Learning\ex03'
   zzzTest_Ng_ML_ex03;
endif
fprintf('\n');


% NG Machine Learning: Ex04
% -------------------------
fprintf('TESTING: NG Machine Learning: Ex04\n');
if input('run? (1/0) = ')
   cd 'D:\Cloud\Box Sync\GitHub\MBALearnsToCode\MatlabOctave\zzzzzzzzzDEMOS\NG - Machine Learning\ex04'
   zzzTest_Ng_ML_ex04;
endif
fprintf('\n');


% NG Machine Learning: Ex05
% -------------------------
fprintf('TESTING: NG Machine Learning: Ex05\n');
if input('run? (1/0) = ')
   cd 'D:\Cloud\Box Sync\GitHub\MBALearnsToCode\MatlabOctave\zzzzzzzzzDEMOS\NG - Machine Learning\ex05'
   zzzTest_Ng_ML_ex05;
endif
fprintf('\n');


% NG Machine Learning: Ex06
% -------------------------
fprintf('TESTING: NG Machine Learning: Ex06\n');
if input('run? (1/0) = ')
   cd 'D:\Cloud\Box Sync\GitHub\MBALearnsToCode\MatlabOctave\zzzzzzzzzDEMOS\NG - Machine Learning\ex06'
   zzzTest_Ng_ML_ex06;
endif
fprintf('\n');


% NG Machine Learning: Ex06: Spam Classif
% ---------------------------------------
fprintf('TESTING: NG Machine Learning: Ex06: Spam Classif\n');
if input('run? (1/0) = ')
   cd 'D:\Cloud\Box Sync\GitHub\MBALearnsToCode\MatlabOctave\zzzzzzzzzDEMOS\NG - Machine Learning\ex06'
   zzzTest_Ng_ML_ex06_spam;
endif
fprintf('\n');