function f = minPos(vec)

   vec_pos = vec(vec > 0);      
   if isempty(vec_pos)
      f = 0;
   else
      f = min(vec_pos);
   endif
   
end