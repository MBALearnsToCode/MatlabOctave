function [trainInput trainTargetOutput ...
   validInput validTargetOutput ...
   testInput testTargetOutput vocab] = ...
   loadData()
   
   load data.mat;
   
   D = rows(data.trainData);   
   trainInput = data.trainData(1 : (D - 1), :)';
   trainTargetOutput = data.trainData(D, :)';
   validInput = data.validData(1 : (D - 1), :)';
   validTargetOutput = data.validData(D, :)';
   testInput = data.testData(1 : (D - 1), :)';
   testTargetOutput = data.testData(D, :)';
   vocab = data.vocab;
    
end