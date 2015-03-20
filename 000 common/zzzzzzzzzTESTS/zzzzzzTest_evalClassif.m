% http://en.wikipedia.org/wiki/Confusion_matrix
% 27 animals — 8 cats, 6 dogs, and 13 rabbits
%                       Predicted class
%                       Cat	Dog	Rabbit
% Actual class	 Cat	5	3	0
%                Dog	2	3	1
%                Rabbit	0	2	11

targetClasses = [1 1 1 1 1 1 1 1 ...
                 2 2 2 2 2 2 ...
                 3 3 3 3 3 3 3 3 3 3 3 3 3];
                 
predClasses =   [1 1 1 1 1 2 2 2 ...
                 1 1 2 2 2 3 ...
                 2 2 3 3 3 3 3 3 3 3 3 3 3];

evalClassif(predClasses, targetClasses)