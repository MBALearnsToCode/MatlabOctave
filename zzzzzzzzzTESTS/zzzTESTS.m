fresh;


% zzzTest_arrProd
% ---------------
fprintf('TESTING: zzzTest_arrProd\n');
zzzTest_arrProd(input('numRuns = '));
fprintf('\n');


% zzzTest_ffNN_gradChk
% --------------------
fprintf('TESTING: zzzTest_ffNN_gradChk\n');
zzzTest_ffNN_gradChk(input('numRuns = '));
fprintf('\n');


% zzzTest_ffNN_vs_linReg_wRegul
% -----------------------------
fprintf('TESTING: zzzTest_ffNN_vs_linReg_wRegul\n');
zzzTest_ffNN_vs_linReg_wRegul(input('numRuns = '));
fprintf('\n');


% zzzTest_ffNN_vs_logReg_wRegul
% -----------------------------
fprintf('TESTING: zzzTest_ffNN_vs_logReg_wRegul\n');
zzzTest_ffNN_vs_logReg_wRegul(input('numRuns = '));
fprintf('\n');


% zzzTest_ffNN_vs_softmReg_wRegul
% -------------------------------
fprintf('TESTING: zzzTest_ffNN_vs_softmReg_wRegul\n');
zzzTest_ffNN_vs_softmReg_wRegul(input('numRuns = '));
fprintf('\n');


% zzzTest_perceptron
% ------------------
fprintf('TESTING: zzzTest_perceptron\n');
zzzTest_perceptron(input('numRuns = '));
fprintf('\n');


% NG Machine Learning: Ex01
% -------------------------
fprintf('TESTING: NG Machine Learning: Ex01\n');
if input('run? (1/0) = ')
   cd 'D:\Users\vinhluong\Dropbox\Knowledge\Computing, Programming\Octave\lib\zzzDEMOS\NG - Machine Learning\ex01'
   zzzTest_Ng_ML_ex01;
endif
fprintf('\n');


% NG Machine Learning: Ex02
% -------------------------
fprintf('TESTING: NG Machine Learning: Ex02\n');
if input('run? (1/0) = ')
   cd 'D:\Users\vinhluong\Dropbox\Knowledge\Computing, Programming\Octave\lib\zzzDEMOS\NG - Machine Learning\ex02'
   zzzTest_Ng_ML_ex02;
endif
fprintf('\n');


% NG Machine Learning: Ex03
% -------------------------
fprintf('TESTING: NG Machine Learning: Ex03\n');
if input('run? (1/0) = ')
   cd 'D:\Users\vinhluong\Dropbox\Knowledge\Computing, Programming\Octave\lib\zzzDEMOS\NG - Machine Learning\ex03'
   zzzTest_Ng_ML_ex03;
endif
fprintf('\n');


% NG Machine Learning: Ex04
% -------------------------
fprintf('TESTING: NG Machine Learning: Ex04\n');
if input('run? (1/0) = ')
   cd 'D:\Users\vinhluong\Dropbox\Knowledge\Computing, Programming\Octave\lib\zzzDEMOS\NG - Machine Learning\ex04'
   zzzTest_Ng_ML_ex04;
endif
fprintf('\n');


% NG Machine Learning: Ex05
% -------------------------
fprintf('TESTING: NG Machine Learning: Ex05\n');
if input('run? (1/0) = ')
   cd 'D:\Users\vinhluong\Dropbox\Knowledge\Computing, Programming\Octave\lib\zzzDEMOS\NG - Machine Learning\ex05'
   zzzTest_Ng_ML_ex05;
endif
fprintf('\n');


% NG Machine Learning: Ex06
% -------------------------
fprintf('TESTING: NG Machine Learning: Ex06\n');
if input('run? (1/0) = ')
   cd 'D:\Users\vinhluong\Dropbox\Knowledge\Computing, Programming\Octave\lib\zzzDEMOS\NG - Machine Learning\ex06'
   zzzTest_Ng_ML_ex06;
endif
fprintf('\n');


% NG Machine Learning: Ex06: Spam Classif
% ---------------------------------------
fprintf('TESTING: NG Machine Learning: Ex06: Spam Classif\n');
if input('run? (1/0) = ')
   cd 'D:\Users\vinhluong\Dropbox\Knowledge\Computing, Programming\Octave\lib\zzzDEMOS\NG - Machine Learning\ex06'
   zzzTest_Ng_ML_ex06_spam;
endif
fprintf('\n');