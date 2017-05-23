% M_019
% General direction rotation
clear all
close all
clc

imgWorkPath = '.\data\';

imgINPath = [imgWorkPath 'in\'];
imgINDir = '000.general_direction\';
imgINName = 'main';
imgINExt = '.png';
imgINMaxCount = 5;

imgOUTUnique = 'mainR_';
imgOUTPath = [imgWorkPath 'out\' imgINDir];
mkdir(imgOUTPath);
imgOUTExt = '.png';
imgOUTNumFormat = '%03d';

testImage = imread([imgINPath imgINDir imgINName imgINExt]);

edgeImage = edge(imadjust(rgb2gray(testImage)), 'canny');

[H,T,~] = hough(edgeImage);

P = houghpeaks(H,imgINMaxCount);

P = T(P(:,2));

[A, ~] = size(P);
if A < imgINMaxCount
    imgINMaxCount = A;
end

for index_0 = 1:imgINMaxCount
    imgOUTName = [imgOUTPath imgOUTUnique num2str(index_0, imgOUTNumFormat) imgOUTExt];
    imwrite(imrotate(testImage, P(index_0), 'loose', 'bicubic'), imgOUTName);
end