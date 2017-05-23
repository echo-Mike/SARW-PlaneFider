% Gradient
clear all
close all
clc
% 1 V/S - value/saturation
% 2 A/M/? - add/multiply/i td
% 3 B/E - binary/edged
% 4 G/_ - op with/not gaus 1-d filter
% 5 F/G/_ - 2-d filtering (Gaus)
% 6-9 N - size of 2-d filter

imgINPath = '.\pics\pic\pic_test_000\in\';
imgINDir = 'gradient\';
imgINName = '';
imgINExt = '.png';

imgOUTUnique = 'VABG_000_';
imgOUTPath = ['.\pics\pic\pic_test_000\out\' imgINDir];
mkdir(imgOUTPath);
imgOUTName = ['out_' imgOUTUnique];
imgOUTExt = '.png';

for index_ = 1:10 
   stepImage = imread([imgINPath imgINDir 'a (' num2str(index_) ')' imgINExt]);
   [stepGrad, stepDir] = imgradient(stepImage);
   
   imwrite(stepGrad, [imgOUTPath imgOUTName 'grad_' num2str(index_) imgOUTExt]);
   imwrite(stepDir, [imgOUTPath imgOUTName 'dir_' num2str(index_) imgOUTExt]);
end