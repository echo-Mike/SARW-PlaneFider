% Detector with gauss experiment M_021 clean
clear all
close all
clc

imgWorkPath = '.\pics\detect\';

imgINPath = [imgWorkPath 'in\'];
imgINDir = 'clean\';
imgINMainName = 'Plane_100';
imgINTemplName = 'template';
imgINExt = '.png';

gaussFiltSize = 0;
gaussPading = 10;
templRotation = 0;

imgOUTUnique = ['X' imgINMainName 'G' num2str(gaussFiltSize) 'P' num2str(gaussPading)];
imgOUTPath = [imgWorkPath 'out\' imgINDir];
imgOUTExt = '.png';

disp(0);
mkdir([imgWorkPath 'out\']);
mkdir(imgOUTPath);

disp(1);
testImage = imread([imgINPath imgINDir imgINMainName imgINExt]);
testTemplate = imread([imgINPath imgINDir imgINTemplName imgINExt]);

testImage = mat2gray(double((testImage)));
% rgb2gray
testImage = padarray(testImage, [gaussPading gaussPading]);

testTemplate = mat2gray(double(testTemplate));
clear imgINPath imgINDir imgINName imgINExt imgWorkPath imgINTemplName;

disp(2);
bufferImg = xcorr2(testImage, testTemplate);

bufferImg = (mat2gray(bufferImg));
imwrite(255*bufferImg, jet(256), [imgOUTPath imgOUTUnique imgOUTExt]);
