% Differencer
clear all
close all
clc

imgINPath = '.\pics\pic\pic_test_000\';
imgINDir = 'in\';
imgINTestDir = 'test_001\';
imgINName = '';
imgINExt = '.png';

imgOUTUnique = '';
imgOUTPath = [imgINPath 'out\' imgINTestDir];
imgOUTName = ['out_' imgOUTUnique];
imgOUTExt = '.png';

for index_ = 1:10
    stepImage1 = imread([imgINPath imgINDir imgINTestDir '1\' num2str(index_) imgINExt]);
    stepImage2 = imread([imgINPath imgINDir imgINTestDir '2\' num2str(index_) imgINExt]);
    h = imshowpair(stepImage1, stepImage2, 'ColorChannels', 'red-cyan');
    imwrite(h.CData(), [imgOUTPath imgOUTName num2str(index_) imgOUTExt]);
end