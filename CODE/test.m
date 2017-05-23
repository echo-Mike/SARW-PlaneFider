% Region detection based on Hue and Saturation
clear all
close all
clc

imgWorkPath = '.\..\pics\pic\pic_test_006\';

imgINPath = [imgWorkPath 'in\'];
imgINDir = '999.test\';
imgINName = 'main';
imgINExt = '.png';

gausFiltSizeH = 10;
gausFiltSizeS = 10;

imgCutLayersH = 3;
imgCutLayersS = 3;

cutThreshold = 0.1;

imgOUTUnique = 'P006B1H3S3';
imgOUTPath = [imgWorkPath 'out\' imgINDir];
mkdir(imgOUTPath);
imgOUTExt = '.png';
imgOUTNumFormat = '%03d';

testImage = imread([imgINPath imgINDir imgINName imgINExt]);
[H, S, V] = rgb2hsv(testImage);

H = imadjust(mat2gray(imgaussfilt(H, gausFiltSizeH)));
S = imadjust(mat2gray(imgaussfilt(S, gausFiltSizeS)));

disp(0)
imgArrayH = imDiffCutter(H, 99, imgCutLayersH);
buffImage = zeros(size(H));

disp(1)
for index_0 = 1:imgCutLayersH
    imgOUTName = [imgOUTPath imgOUTUnique 'H' num2str((imgCutLayersH-index_0 + 1), imgOUTNumFormat) imgOUTExt];
    imgArrayH(:,:,index_0) = imgaussfilt(imgArrayH(:,:,index_0), gausFiltSizeH);
    imgArrayH(:,:,index_0) = imadjust(imgArrayH(:,:,index_0));
    imgArrayH(:,:,index_0) = imbinarize(imgArrayH(:,:,index_0), cutThreshold);
    buffImage = buffImage + imgArrayH(:,:,index_0);
    imwrite(imgArrayH(:,:,index_0), imgOUTName);
end

disp(2)
imwrite(256*imadjust(mat2gray(buffImage)), jet(256), [imgOUTPath imgOUTUnique 'HCombMask' imgOUTExt]);

for index_0 = 1:imgCutLayersH
    imgOUTName = [imgOUTPath imgOUTUnique 'HV' num2str((imgCutLayersH-index_0 + 1), imgOUTNumFormat) imgOUTExt];
    imwrite(imgArrayH(:,:,index_0) .* V, imgOUTName);
end

buffImage = zeros([size(H) 3]);
for index_0 = 1:imgCutLayersH
    imgOUTName = [imgOUTPath imgOUTUnique 'HVC' num2str((imgCutLayersH-index_0 + 1), imgOUTNumFormat) imgOUTExt];
    buffImage(:,:,1) = imgArrayH(:,:,index_0) .* double(testImage(:,:,1));
    buffImage(:,:,2) = imgArrayH(:,:,index_0) .* double(testImage(:,:,2));
    buffImage(:,:,3) = imgArrayH(:,:,index_0) .* double(testImage(:,:,3));
    imwrite(uint8(buffImage), imgOUTName);
end

disp(3)
imgArrayH = imDiffCutter(S, 99, imgCutLayersS);
buffImage = zeros(size(H));

disp(4)
for index_0 = 1:imgCutLayersS
    imgOUTName = [imgOUTPath imgOUTUnique 'S' num2str((imgCutLayersS-index_0 + 1), imgOUTNumFormat) imgOUTExt];
    imgArrayH(:,:,index_0) = imgaussfilt(imgArrayH(:,:,index_0), gausFiltSizeS);
    imgArrayH(:,:,index_0) = imadjust(imgArrayH(:,:,index_0));
    imgArrayH(:,:,index_0) = imbinarize(imgArrayH(:,:,index_0), cutThreshold);
    buffImage = buffImage + imgArrayH(:,:,index_0);
    imwrite(imgArrayH(:,:,index_0), imgOUTName);
end

disp(5)
imwrite(256*imadjust(mat2gray(buffImage)), jet(256), [imgOUTPath imgOUTUnique 'SCombMask' imgOUTExt]);

for index_0 = 1:imgCutLayersS
    imgOUTName = [imgOUTPath imgOUTUnique 'SV' num2str((imgCutLayersS-index_0 + 1), imgOUTNumFormat) imgOUTExt];
    imwrite(imgArrayH(:,:,index_0) .* V, imgOUTName);
end

buffImage = zeros([size(H) 3]);
for index_0 = 1:imgCutLayersH
    imgOUTName = [imgOUTPath imgOUTUnique 'SVC' num2str((imgCutLayersH-index_0 + 1), imgOUTNumFormat) imgOUTExt];
    buffImage(:,:,1) = imgArrayH(:,:,index_0) .* double(testImage(:,:,1));
    buffImage(:,:,2) = imgArrayH(:,:,index_0) .* double(testImage(:,:,2));
    buffImage(:,:,3) = imgArrayH(:,:,index_0) .* double(testImage(:,:,3));
    imwrite(uint8(buffImage), imgOUTName);
end

% buffImage = zeros([size(H) 3]);
% buffImage(:,:,1) = imgArrayH(:,:,1) .* double(testImage(:,:,1));
% buffImage(:,:,2) = imgArrayH(:,:,1) .* double(testImage(:,:,2));
% buffImage(:,:,3) = imgArrayH(:,:,1) .* double(testImage(:,:,3));
% buffImage = buffImage);
% imshow(buffImage);
