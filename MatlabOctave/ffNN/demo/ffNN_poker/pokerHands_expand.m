function f = pokerHands_expand(cards)

   f = eye(13)(cards(:, 1), :);
   f = [f eye(4)(cards(:, 2), :)];
   f = [f eye(13)(cards(:, 3), :)];
   f = [f eye(4)(cards(:, 4), :)];
   f = [f eye(13)(cards(:, 5), :)];
   f = [f eye(4)(cards(:, 6), :)];
   f = [f eye(13)(cards(:, 7), :)];
   f = [f eye(4)(cards(:, 8), :)];
   f = [f eye(13)(cards(:, 9), :)];
   f = [f eye(4)(cards(:, 10), :)];

endfunction