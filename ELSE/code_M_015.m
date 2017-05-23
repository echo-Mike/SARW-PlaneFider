% Filter + Edge
clear all
close all
clc
% 1 V/S - value/saturation
% 2 A/M/? - add/multiply/i td
% 3 B/E - binary/edged
% 4 G/_ - op with/not gaus 1-d filter
% 5 F/G/_ - 2-d filtering (Gaus)
% 6-7 N - size of 2-d filter

imgWorkPath = '.\pics\pic\pic_test_001\';

imgINPath = [imgWorkPath 'in\'];
imgINDir = 'FEdge\';
imgINName = '';
imgINExt = '.png';
imgINCount = 10;

imgOUTUnique = 'VAEGG05_';
imgOUTPath = [imgWorkPath 'out\' imgINDir];
mkdir(imgOUTPath);
imgOUTExt = '.png';
imgOUTNumFormat = '%03d';

imgFilter = 'canny';

for index_ = 1:imgINCount 
   stepImage = double(imread([imgINPath imgINDir 'a (' num2str(index_) ')' imgINExt]));
   % Gaus + adjust
   stepImage = imadjust(imgaussfilt(stepImage, 5));
   edgeImage = edge(stepImage, imgFilter);
   revEdgeImage = edge(1 - mat2gray(stepImage), imgFilter);
   
   imwrite(edgeImage, [imgOUTPath imgOUTUnique 'S' num2str(index_, imgOUTNumFormat) imgOUTExt]);
   imwrite(revEdgeImage, [imgOUTPath imgOUTUnique 'R' num2str(index_, imgOUTNumFormat) imgOUTExt]);
end