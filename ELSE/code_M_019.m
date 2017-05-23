% general direction rotation
clear all
close all
clc

imgWorkPath = '.\pics\pic\pic_test_001\';

imgINPath = [imgWorkPath 'in\'];
imgINDir = 'general_direction\';
imgINName = 'main';
imgINExt = '.png';
imgINMaxCount = 5;

imgOUTUnique = 'mainR_';
imgOUTPath = [imgWorkPath 'out\' imgINDir];
mkdir(imgOUTPath);
imgOUTExt = '.png';
imgOUTNumFormat = '%03d';

testImage = imread([imgWorkPath imgINName imgINExt]);

edgeImage = edge(imadjust(rgb2gray(testImage)), 'canny');

[H,T,R] = hough(edgeImage);

P = houghpeaks(H,imgINMaxCount);

[A, ~] = size(P);
if A < imgINMaxCount
    imgINMaxCount = A;
end

for index_0 = 1:imgINMaxCount
    buff = mod(P(index_0,2), 90);
    if buff > 45 
        imwrite(imrotate(testImage, buff - 90, 'loose', 'bicubic'), [imgOUTPath imgOUTUnique num2str(index_0, imgOUTNumFormat) imgOUTExt]);
    else
        imwrite(imrotate(testImage, buff, 'loose', 'bicubic'), [imgOUTPath imgOUTUnique num2str(index_0, imgOUTNumFormat) imgOUTExt]);
    end
end

