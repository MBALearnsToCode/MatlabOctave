function zzzTest_Hinton_NNML_ex03

   fprintf('\nQUESTION 1: Training Loss = 2.30259\n');
   a3(0, 0, 0, 0, 0, false, 0);
   fprintf('\n');
   
   fprintf('QUESTION 2: Training Loss = 2.30344\n');
   a3(0, 10, 70, 0.005, 0, false, 4);
   fprintf('\n');
   
   fprintf('QUESTION 5: Validation Loss = 0.43019\n');
   a3(0, 200, 1000, 0.35, 0.9, false, 100);
   fprintf('\n');
   
   fprintf('QUESTION 6: Validation Loss = 0.334505\n');
   a3(0, 200, 1000, 0.35, 0.9, true, 100);
   fprintf('\n');
   
   fprintf('QUESTION 8-10: Test Error Rate = 0.084333\n');
   a3(0, 37, 1000, 0.35, 0.9, true, 100);
   fprintf('\n');

endfunction