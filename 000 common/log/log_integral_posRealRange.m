function f = log_integral_posRealRange(x_from, x_to) 
   
   f = log_integral_posReal(x_to) ...
      - log_integral_posReal(x_from);
   
endfunction