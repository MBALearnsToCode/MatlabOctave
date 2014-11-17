function f = convertText_toPokerHand(text)
   
   ranks = const_cardRanks;
   suits = const_cardSuits;   
 
   [~, f(1, 1)] = ismember(text(1), ranks);
   [~, f(1, 2)] = ismember(text(2), suits);
   [~, f(1, 3)] = ismember(text(4), ranks);
   [~, f(1, 4)] = ismember(text(5), suits);
   [~, f(1, 5)] = ismember(text(7), ranks);
   [~, f(1, 6)] = ismember(text(8), suits);
   [~, f(1, 7)] = ismember(text(10), ranks);
   [~, f(1, 8)] = ismember(text(11), suits);
   [~, f(1, 9)] = ismember(text(13), ranks);
   [~, f(1, 10)] = ismember(text(14), suits);
   
endfunction