% Создаём варианты изображения послойно с окном, только VE + SE
clear all
close all
clc

% 1 G - 2-d filtering (Gaus)
% 2-3 N - size of 2-d filter
% 4 S/G/B/Z - Strait/Gaus/Binarize/G+B
% 5-6 N - size of filter
% 7 W - window ind
% 8 N - window size
% 9 C - crytaria ind
% 10 N - crytaria size

imgWorkPath = '.\pics\pic\pic_test_006\';

imgINPath = [imgWorkPath 'in\'];
imgINDir = 'generatorVE\';
imgINName = 'main';
imgINExt = '.png';

imgOUTUnique = 'G';
imgOUTPath = [imgWorkPath 'out\' imgINDir];
imgOUTExt = '.png';
imgOUTNumFormat = '%02d';

slices = 100;
outLayers = 10;

dataFileName = 'zzz_data_';

disp(0)
slicesPerLayer = slices / outLayers;
mkdir([imgWorkPath 'out\']);
mkdir(imgOUTPath);

testImage = imread([imgINPath imgINDir imgINName imgINExt]);
clear imgINPath imgINDir imgINName imgINExt imgWorkPath;

[~, S, V] = rgb2hsv(testImage);
V = imadjust(V);
S = imadjust(S);

win = gausswin(slicesPerLayer);
% win = ones(slicesPerLayer, 1);

% Создаём файл логирования информации
dataFile = fopen( [imgOUTPath dataFileName imgOUTUnique '.txt'], 'w+');
fprintf(dataFile, ['Slices: ' num2str(slices) '\r\n']);
fprintf(dataFile, ['OutLayers: ' num2str(outLayers) '\r\n']);
fclose(dataFile);
clear dataFile;

disp(1)
imArrayV = imDiffCutterWin(V, slices, outLayers, win);
disp(2)
imArrayS = imDiffCutterWin(S, slices, outLayers, win);

disp(3)
for index_0 = 1:outLayers
    imgTMPCallInfo = num2str(index_0, imgOUTNumFormat);
    imwrite(mat2gray(imArrayV(:,:,index_0)), [imgOUTPath 'VAE' imgOUTUnique imgTMPCallInfo imgOUTExt]);
    imwrite(mat2gray(imArrayS(:,:,index_0)), [imgOUTPath 'SAE' imgOUTUnique imgTMPCallInfo imgOUTExt]);
end