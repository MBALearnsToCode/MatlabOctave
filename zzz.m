% This script does the following:
% 1. Clear all variables from memory
% 2. Close all plot windows
% 3. Clear the output screen
% 4. Set working directory
% 5. Add folders to the search path

warningSettings;

PS1('CMD>>>   '); clear; close all; clc;

cd 'D:\Cloud\Dropbox\MBALearnsToCode\youTeach_machineLearn';
addpath(genpath...
   ('D:\Cloud\Dropbox\MBALearnsToCode\youTeach_machineLearn'));

more off;