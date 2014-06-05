function f = randElem(Arr_or_list)
   
   if ismatrix(Arr_or_list)
      f = Arr_or_list(unidrnd(numel(Arr_or_list)));      
   else   
      f = Arr_or_list{unidrnd(numel(Arr_or_list))};
   endif

end