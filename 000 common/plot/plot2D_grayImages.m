function [graphicHandle plotMat] = plot2D_grayImages...
   (grayImages_arr3D_casesInD3, numCols = 0, pad = 1)
 
   [imageHeight imageWidth numImages] = ...
      size(grayImages_arr3D_casesInD3);
   if ~(numCols)
	   numCols = round(sqrt(numImages));
   endif  
   numRows = ceil(numImages / numCols);
      
   plotMat = - ones...
      ([(numRows * (imageHeight + pad) + pad) ...
      (numCols * (imageWidth + pad) + pad)]);
                       
   % Copy each example into a patch on the display array
   for (i = 1 : numRows)
	   for (j = 1 : numCols)
         currImageNum = (i - 1) * numCols + j;         
		   if (currImageNum > numImages), 
			   break; 
		   endif			
         currImage = grayImages_arr3D_casesInD3...
            (:, :, currImageNum);
		   plotMat...
            (pad + (i - 1) * (imageHeight + pad) ...
            + (1 : imageHeight), ...
		      pad + (j - 1) * (imageWidth + pad) ...
            + (1 : imageWidth)) = ...
            currImage / max(abs(currImage(:)));
	   endfor
	   if (currImageNum > numImages)
		   break;
	   endif
   endfor

   % Display Image
   figure;
   colormap(gray);
   h = imagesc(plotMat, [-1 1]);
   
   % Do not show axis
   axis image off;   
   %drawnow;

endfunction