% Оконечная программа
clear all
close all
clc

imgWorkPath = '.\pics\pic\pic_test_001\';

imgINMainName = 'main';
imgINTemplateName = 'template';
imgINExt = '.png';
% Размер самолёта от носа до хвоста в пикселях
% Можно задать вектором : [1 2 3]
planeSize = 74;
% Размер ограждающей самолёт коробки (в каждую сторону)
% Можно задать вектором : [1 2 3]
paddingSize = 10;
% Сколько искать самолётов на картинке
planesEstimatedCount = 3;
% Количество направлений вращения, в которых происходит анализ 8 или 16 и
% больше.
analyzedDirectionsCount = 8;

imgOUTUnique = '';
imgOUTPath = [imgWorkPath 'out\'];
imgOUTExt = '.png';

imgOUTNumFormat = '%03d';

disp('0) Loading images')
% Создаём папку для выходных изображений
mkdir(imgOUTPath);

% Загружаем изображение с диска
testImage = imread([imgWorkPath imgINMainName imgINExt]);
% testImage = double(testImage);
% Получим размеры исходного изображения
[mainImgWidth, mainImgHeight, ~] = size(testImage);

% Загружаем шаблон поиска с диска
testTemplate = imread([imgWorkPath imgINTemplateName imgINExt]);
% rgb2gray
testTemplate = double((testTemplate));

% Преобразуем основное изображение в hsv форму
[H, S, V] = rgb2hsv(testImage);

disp('1) Finding main lines')
% Находим углы поворота основных линий изображения
mainLines = findMainLines(imadjust(rgb2gray(testImage)), 5);
% Костыль : получам одну основную линию по минимальному по модулю углу поворота.
mainLine = min(1i * mainLines) / 1i;
if mod(mainLine, 360/analyzedDirectionsCount) == 0
    mainLine = 0;
end
clear mainLines;

disp('2) Creating masks')
% Получаем маски по оттенку и нассыщенности
% Радиус Гаусс-размытия : 10
% Количество базовых слоёв : 99
% Количество масок : 3
% Порог бинаризации : 0.1
hMasksImgArray = createMasks(H, 10, 99, 3, 0.1);
sMasksImgArray = createMasks(S, 10, 99, 3, 0.1);
masksImgArray = cat(3, hMasksImgArray, sMasksImgArray);
clear hMasksImgArray sMasksImgArray;

disp('3) Taking binarized differentials')
% Задаём окно для взятия производной
% Количество базовых слоёв : 100
% Количество получаемых слоёв : 10
win = gausswin(100/10);
% Берём бинаризированную производную для оттенка и нассыщенности
vDiffImgArray = imDiffCutterWin(V, 100, 10, win);
sDiffImgArray = imDiffCutterWin(S, 100, 10, win);
clear H S V win;

disp('4) Creatimg search arrays')
% Получаем исследуемое изображение с применением размытия 
% и предвыделения краёв, в нескольких вариантах.
% Два критерия : 2 из 3 и 3 из 5 - 3 из 5 более чистый критерий чем 2 из 3
criterion = [3, 2; 5, 3;];
% criterion = [5, 3];
% Три размытия : 5 - крупные самолёты, 3 - средние, 1 -маленькие - по
% отношению к размерам и разрешению картинки.
gaussFilterSizes = [5, 3, 1];
% gaussFilterSizes = 1;

disp(4.1)
% Сначала для светового потока
vSearchImgArray = zeros(mainImgWidth, mainImgHeight, size(criterion,1) * size(gaussFilterSizes,2));
for index_0 = 1:size(criterion,1)
    for index_1 = 1:size(gaussFilterSizes,2)
        vSearchImgArray(:,:,(index_0-1)*3+index_1) = createArialImage(vDiffImgArray, criterion(index_0, 1), criterion(index_0, 2), gaussFilterSizes(index_1), 0.1);
    end
end
disp(4.2)
% Затем для нассыщенности
sSearchImgArray = zeros(mainImgWidth, mainImgHeight, size(criterion,1) * size(gaussFilterSizes,2));
for index_0 = 1:size(criterion,1)
    for index_1 = 1:size(gaussFilterSizes,2)
        sSearchImgArray(:,:,(index_0-1)*3+index_1) = createArialImage(sDiffImgArray, criterion(index_0, 1), criterion(index_0, 2), gaussFilterSizes(index_1), 0.1);
    end
end
% Подчищаем память
clear vDiffImgArray sDiffImgArray;

disp('5) Rotating images')
% Поворачиваем исследуемые изображения
if mainLine ~= 0 
    RtestImage = imrotate(testImage, mainLine, 'loose', 'bicubic');
    clear testImage;
    imwrite(uint8(RtestImage), [imgOUTPath 'mainRotated' imgOUTExt]);
    RvSearchArray = imrotate(vSearchImgArray(:,:,1), mainLine, 'loose', 'bicubic');
    RsSearchArray = imrotate(sSearchImgArray(:,:,1), mainLine, 'loose', 'bicubic');
    if size(vSearchImgArray, 3) > 1
        for index_0 = 2:size(vSearchImgArray,3)
            RvSearchArray = cat(3, RvSearchArray, imrotate(vSearchImgArray(:,:,index_0), mainLine, 'loose', 'bicubic'));
            RsSearchArray = cat(3, RsSearchArray, imrotate(sSearchImgArray(:,:,index_0), mainLine, 'loose', 'bicubic'));
        end
    end
    clear vSearchImgArray sSearchImgArray;
    RmasksImgArray = imrotate(masksImgArray(:,:,1), mainLine, 'loose', 'bicubic');
    for index_0 = 2:size(masksImgArray,3)
        RmasksImgArray = cat(3, RmasksImgArray, imrotate(masksImgArray(:,:,index_0), mainLine, 'loose', 'bicubic'));
    end
    clear masksImgArray;
else
    RtestImage = testImage;
    clear testImage;
    imwrite(uint8(RtestImage), [imgOUTPath 'mainRotated' imgOUTExt]);
    RvSearchArray = vSearchImgArray;
    RsSearchArray = sSearchImgArray;
    clear vSearchImgArray sSearchImgArray;
    RmasksImgArray = masksImgArray;
    clear masksImgArray;
end

codeNames = ['H0';'H1';'H2';'S0';'S1';'S2'];

disp('6) Evaluating alorithm')
% Количество глобалных шагов алгоритма равно количеству размеров искомых
% самолётов
stepsCount = max(size(planeSize));
% Выполняем алгоритм
% 6 - количество изображений в SearchImgArray'ях 
% 3 - количество масок для каждого канала
for index_0 = 1:stepsCount
    stepTemplate = imresize(testTemplate, planeSize(index_0)/size(testTemplate, 1));
    
    % Для каждой маски отдельный поиск
    for index_1 = 1:size(RmasksImgArray, 3)
        
        disp([num2str(index_0) ') VFP: ' codeNames(index_1,:)])
        uniqeName = [imgOUTUnique 'VS' codeNames(index_1,:) num2str(planeSize(index_0))];
        % Для Светового потока
        vResultTable = imFindPlanes(RvSearchArray, stepTemplate, RmasksImgArray(:,:,index_1), analyzedDirectionsCount, planesEstimatedCount, imgOUTPath, uniqeName);
        
        disp([num2str(index_0) ') VCP: ' codeNames(index_1,:)])
        % Вырезаем полученные самолёты
        vResultImage = imCutPlanes(RtestImage, vResultTable, planesEstimatedCount, planeSize(index_0), paddingSize(index_0), imgOUTPath, uniqeName);
        
        % Сохраняем полученную карту распределения вероятности
        imwrite(255*mat2gray(vResultImage), jet(256), [imgOUTPath imgOUTUnique codeNames(index_1,:) 'VEstimationN' num2str(index_0,imgOUTNumFormat) imgOUTExt]);
        
        % Выгружем таблицы результатов в файл на хранение
        logFile = fopen([imgOUTPath imgOUTUnique 'Vlog' num2str(index_0,imgOUTNumFormat) codeNames(index_1,:) '.txt'],'w+');
        for index_2 = 1:size(vResultTable, 1)
            fprintf(logFile, [num2str(vResultTable(index_2,1)) '\t' num2str(vResultTable(index_2,2)) '\t' num2str(vResultTable(index_2,1)) '\r\n']);
        end
        fclose(logFile);
        
        disp([num2str(index_0) ') SFP: ' codeNames(index_1,:)])
        uniqeName = [imgOUTUnique 'SS' codeNames(index_1,:) num2str(planeSize(index_0))];
        % Для нассыщенности
        sResultTable = imFindPlanes(RsSearchArray, stepTemplate, RmasksImgArray(:,:,index_1), analyzedDirectionsCount, planesEstimatedCount, imgOUTPath, uniqeName);
        
        disp([num2str(index_0) ') SCP: ' codeNames(index_1,:)])
        % Вырезаем полученные самолёты
        sResultImage = imCutPlanes(RtestImage, sResultTable, planesEstimatedCount, planeSize(index_0), paddingSize(index_0), imgOUTPath, uniqeName);
        
        % Сохраняем полученную карту распределения вероятности
        imwrite(255*mat2gray(sResultImage), jet(256), [imgOUTPath imgOUTUnique codeNames(index_1,:) 'SEstimationN' num2str(index_0,imgOUTNumFormat) imgOUTExt]);
        
        % Выгружем таблицы результатов в файл на хранение
        logFile = fopen([imgOUTPath imgOUTUnique 'Slog' num2str(index_0,imgOUTNumFormat) codeNames(index_1,:) '.txt'],'w+');
        for index_2 = 1:size(vResultTable, 1)
            fprintf(logFile, [num2str(vResultTable(index_2,1)) '\t' num2str(vResultTable(index_2,2)) '\t' num2str(vResultTable(index_2,1)) '\r\n']);
        end
        fclose(logFile);
    end
end
