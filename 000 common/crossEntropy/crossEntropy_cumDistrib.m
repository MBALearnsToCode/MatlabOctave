function f = crossEntropy_cumDistrib(p_or_x, given = 'p')
    
    switch (given)
       case ('p')
          f = - exp(- p_or_x) * (p_or_x + 1) + 1;
       case ('x')
          f = p_or_x * (log(p_or_x) - 1) + 1;
    endswitch
    
endfunction