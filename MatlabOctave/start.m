% This script does the following:
% 1. Clear all variables from memory
% 2. Close all plot windows
% 3. Clear the output screen
% 4. Set working directory
% 5. Add folders to the search path

addpath(genpath(pwd()));
warningSettings;
PS1('CMD>>>   ');
more off;
figure;
close all; clc;