% Area detector
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
% 9 F/S/G/B/Z - filter/Strait/Gaus/Binarize/G+B
% 10-11 N - size of filter
% 12 W - window ind
% 13 N - window size
% 14 C - crytaria ind
% 15 N - crytaria size

imgWorkPath = '.\pics\pic\pic_test_006\';

imgINPath = [imgWorkPath 'in\'];
imgINDir = 'area\';
imgINName = '';
imgINExt = '.png';
imgINCount = 10;
imgINWinsize = 3;
imgINCryteria = 2;
imgGaussSize = 1;
imgBinThreshold = 0.1;
imgINNumFormat = '%02d';

imgOUTUnique = ['MaskS03G' num2str(imgGaussSize) 'T' num2str(imgBinThreshold) 'W' num2str(imgINWinsize) 'C' num2str(imgINCryteria)];
imgOUTPath = [imgWorkPath 'out\' imgINDir];
mkdir(imgOUTPath);
imgOUTExt = '.png';
imgOUTNumFormat = '%03d';

disp(0)
[imgINW, imgINH] = size(imread([imgINPath imgINDir 'SAEG01' imgINExt]));
imgBuffer = zeros(imgINW, imgINH);
stepImage = zeros(imgINW, imgINH, imgINWinsize);
% stepBuffer = zeros(imgINW, imgINH);

disp(1)
for index_0 = 1:imgINCount-imgINWinsize+1
    for index_1 = 1:imgINWinsize
        stepImage(:,:,index_1) = imbinarize(imgaussfilt(double(imread([imgINPath imgINDir 'SAEG' num2str(index_0+index_1-1, imgINNumFormat) imgINExt])), imgGaussSize), imgBinThreshold);
    end
    for index_1 = 1:imgINWinsize - imgINCryteria + 1
        stepBuffer = stepImage(:,:,index_1);
        for index_2 = 1:imgINCryteria-1
            stepBuffer = stepBuffer .* stepImage(:,:,index_1+index_2);
        end
        imgBuffer = imgBuffer + stepBuffer;
    end
end

disp(2)
imwrite(255 * mat2gray(imgBuffer), jet(256), [imgOUTPath 'SAEG' imgOUTUnique imgOUTExt]);

imgBuffer = zeros(imgINW, imgINH);
stepImage = zeros(imgINW, imgINH, imgINWinsize);
% stepBuffer = zeros(imgINW, imgINH);

disp(3)
for index_0 = 1:imgINCount-imgINWinsize+1
    for index_1 = 1:imgINWinsize
        stepImage(:,:,index_1) = imbinarize(imgaussfilt(double(imread([imgINPath imgINDir 'VAEG' num2str(index_0+index_1-1, imgINNumFormat) imgINExt])), imgGaussSize), imgBinThreshold);
    end
    for index_1 = 1:imgINWinsize - imgINCryteria + 1
        stepBuffer = stepImage(:,:,index_1);
        for index_2 = 1:imgINCryteria-1
            stepBuffer = stepBuffer .* stepImage(:,:,index_1+index_2);
        end
        imgBuffer = imgBuffer + stepBuffer;
    end
end

disp(4)
imwrite(255 * mat2gray(imgBuffer), jet(256), [imgOUTPath 'VAEG' imgOUTUnique imgOUTExt]);