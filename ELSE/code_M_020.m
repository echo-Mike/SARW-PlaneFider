% Scan region cutter
clear all
close all
clc
% 1 V/S - value/saturation
% 2 A/M/? - add/multiply/i td
% 3 B/E - binary/edged
% 4 G/_ - op with/not gaus 1-d filter
% 5 F/G/_ - 2-d filtering (Gaus)
% 6-7 N - size of 2-d filter
% 8 S/R - strait/reversed
% 9 F/S/G/B - filter/Strait/Gaus/Binarize
% 10-11 N - size of filter
% 12 W - window ind
% 13 N - window size
% 14 C - crytaria ind
% 15 N - crytaria size

imgWorkPath = '.\pics\pic\pic_test_001\';

imgINPath = [imgWorkPath 'in\'];
imgINDir = 'region_cutter\';
imgINName = 'main';
imgINExt = '.png';
imgINCount = 10;

imgOUTUnique = 'VAEGG75_';
imgOUTPath = [imgWorkPath 'out\' imgINDir];
mkdir(imgOUTPath);
imgOUTExt = '.png';
imgOUTNumFormat = '%03d';

testImage = double(imread([imgINPath imgINDir imgINName imgINExt]));

for index_ = 1:imgINCount 
   stepImage = double(imread([imgINPath imgINDir 'a (' num2str(index_) ')' imgINExt]));
   imwrite(testImage .* stepImage, [imgOUTPath imgOUTUnique num2str(index_, imgOUTNumFormat) imgOUTExt]);
end