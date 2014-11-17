function f = convertTexts_toPokerHands(texts)   
   
   if strcmp(class(texts), 'char')
      f = convertText_toPokerHand(texts);
   else
      numPokerHands = length(texts);
      f = zeros(numPokerHands, 10);
      for (i = 1 : numPokerHands)      
         f(i, :) = convertText_toPokerHand(texts{i});
      endfor
   endif
 
endfunction