% Detector with gaus experiment M_021 main noise Gauss + Binarize + Rotation
clear all
close all
clc

imgWorkPath = '.\pics\detect\';

imgINPath = [imgWorkPath 'in\'];
imgINDir = 'G_B_R\';
imgINMainName = 'main';
imgINTemplName = 'template';
imgINExt = '.png';

gaussFiltSize = 5;
binarizeThreshold = 0.293;
templRotation = 5;

imgOUTUnique = ['G' num2str(gaussFiltSize) 'B' num2str(binarizeThreshold) 'TR' num2str(templRotation)];
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
testImage = double(imbinarize(imadjust(imgaussfilt(testImage, gaussFiltSize)), binarizeThreshold));

testTemplate = mat2gray(double(imrotate(testTemplate, templRotation, 'loose', 'bilinear')));
clear imgINPath imgINDir imgINName imgINExt imgWorkPath imgINTemplName;

disp(2);
bufferImg = xcorr2(testImage, testTemplate);

figure;
p = houghpeaks(floor(bufferImg), 10);
imagesc(bufferImg)
colormap('jet')
hold on
plot(p(:,2),p(:,1),'s','color','black');

logFile = fopen([imgOUTPath imgOUTUnique '_log.txt'], 'w+');
for index_0 = 1:size(p,1)
    fprintf(logFile, [num2str(p(index_0,2)) '\t' num2str(p(index_0,1)) '\t' num2str(bufferImg(p(index_0,1),p(index_0,2))) '\r\n']);
end
fclose(logFile);
clear logFile;

bufferImg = mat2gray(bufferImg);
imwrite(255*bufferImg, jet(256), [imgOUTPath imgOUTUnique imgOUTExt]);

