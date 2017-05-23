% Detector
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
imgINDir = '';
imgINMainName = 'main';
imgINTemplName = 'template';
imgINExt = '.png';

imgOUTUnique = '';
imgOUTPath = [imgWorkPath 'out\' imgINDir];
imgOUTExt = '.png';

disp(0);
mkdir([imgWorkPath 'out\']);
mkdir(imgOUTPath);

disp(1);
testImage = imread([imgINPath imgINDir imgINMainName imgINExt]);
testTemplate = imread([imgINPath imgINDir imgINTemplName imgINExt]);
% testImage = mat2gray(double(rgb2gray(imrotate(testImage, 180, 'crop', 'bilinear'))));
testImage = mat2gray(double(rgb2gray(testImage)));
testTemplate = mat2gray(double(rgb2gray(testTemplate)));
% [templW, templH] = size(testTemplate);
% testTemplate = imresize(testTemplate, 80/templW);
clear imgINPath imgINDir imgINName imgINExt imgWorkPath imgINTemplName;

high = max(max(testImage));

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
        if testImage(index_1, index_0) > 0.5
            bufferImg = imAddByCoord(testTemplate * testImage(index_1, index_0), bufferImg, index_1 + templWHalf, index_0 + templHHalf);
%             bufferImg = imMultiplyByCoord(testTemplate, bufferImg, index_1 + templWHalf, index_0 + templHHalf);
        end
    end
end
c = jet(256);

imwrite(256*imadjust(mat2gray(bufferImg)), c, [imgOUTPath imgOUTUnique 'output' imgOUTExt]);

