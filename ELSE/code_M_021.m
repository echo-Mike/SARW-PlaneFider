% Detector with gaus experiment
clear all
close all
clc

% Алгоритм
% 1 Задаём:
%     1 Картинку с найденными рёбрами
%     2 Шаблон
% 2 Производим фильтрацию изображения:
%     В каждом пикселе:
%     1 добавляем Шаблон к буферу с коэфициентом текущего пикселя
%         (так рёбра вносят вес а не рёбра не вносят)
% 
% Центр шаблона - ценр искомой фигуры

imgWorkPath = '.\pics\detect\';

imgINPath = [imgWorkPath 'in\'];
imgINDir = 'main\';
imgINMainName = 'main';
imgINTemplName = 'template';
imgINExt = '.png';

gaussFiltSize = 5;
gaussPading = 10;
threshold = 0;
binarizeThreshold = 0.293;
templRotation = 22.5;

imgOUTUnique = ['N100G' num2str(gaussFiltSize) 'P' num2str(gaussPading) 'T' num2str(threshold) 'B' num2str(binarizeThreshold) 'TR' num2str(templRotation)];
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
testImage = imbinarize(imadjust(imgaussfilt(testImage, gaussFiltSize)), binarizeThreshold);

testTemplate = mat2gray(double(imrotate(testTemplate, templRotation, 'loose', 'bilinear')));
% testTemplate = mat2gray(double(testTemplate));

% [templW, templH] = size(testTemplate);
% testTemplate = imresize(testTemplate, 80/templW);
clear imgINPath imgINDir imgINName imgINExt imgWorkPath imgINTemplName;

disp(2);
% Формируем буфер
[templW, templH] = size(testTemplate);
[mainW, mainH] = size(testImage);
templWHalf = ceil(templW/2);
templHHalf = ceil(templH/2);
bufferImgW = templW + mainW + 2;
bufferImgH = templH + mainH + 2;

bufferImg = ones(bufferImgW, bufferImgH);
for index_0 = 1:mainH
    for index_1 = 1:mainW
        if testImage(index_1, index_0) > threshold
            bufferImg = imAddByCoord(testTemplate * testImage(index_1, index_0), bufferImg, index_1 + templWHalf, index_0 + templHHalf);
        end
    end
end

figure;
imagesc(testImage);
figure;
p = houghpeaks(floor(1024*bufferImg), 10);
imagesc(bufferImg)
colormap('jet')
hold on
plot(p(:,2),p(:,1),'s','color','white');

bufferImg = (mat2gray(bufferImg));
imwrite(256*bufferImg, jet(256), [imgOUTPath imgOUTUnique imgOUTExt]);

