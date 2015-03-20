function [predicted_labels targetOutput_labels misclassifs_indices] = ...
   ffNN_handwrittenDigits_analyseMisclassifs...
   (ffNN, inputImages, targetOutput_labels)
   
   inputImages_eachIsVector = inputImages(:, :);
   predicted_labels = predict(ffNN, inputImages_eachIsVector);
   misclassifs_indices = (1 : length(targetOutput_labels))...
     (predicted_labels != targetOutput_labels);
     
   predicted_labels = predicted_labels(misclassifs_indices);
   predicted_labels(predicted_labels == 10) = 0;
   
   targetOutput_labels = targetOutput_labels(misclassifs_indices);
   targetOutput_labels(targetOutput_labels == 10) = 0;
   
   plot2D_grayImages...
      (permute(inputImages(misclassifs_indices, :, :), ...
      [2 3 1])); 
   
endfunction