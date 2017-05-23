% Data former 
clear all
close all
clc
% 1 V/S - value/saturation
% 2 A/M/? - add/multiply/i td
% 3 B/E - binary/edged
% 4 G/_ - op with/not gaus 1-d filter
% 5 F/G/_ - 2-d filtering (Gaus)
% 6-9 N - size of 2-d filter

% Алгоритм:
% 1 Загрузить исходное изображение
% 2 Проделать с ним 003
%     1 Преобразовать в S и V
%     2 imadjust оба
%     3 задать количество делений (slices) и шаг (sliceStep)
%     4 задать окно 1-D
%     5 для всех slices/sliceStep выборок:
%         1 бинаризировать исходное по скользящему порогу
%         2 OP с окном акамулируем в буфере и делаем детекцию краёв
%         3 записываем буферы в TMP
% 3 Для каждого буфера:
%     1 Добить до делимости на imgOUTSizeHalf
%     2 Разрезать на фрагменты по imgOUTSizeHalfXimgOUTSizeHalf
%     3 Собрать фрагменты в фрагменты imgOUTSizeXimgOUTSize по схеме перекрытия
%     4 Сохранять фрагменты по мере готовности

imgWorkPath = '.\pics\pic\pic_test_001\';

imgINPath = [imgWorkPath 'in\'];
imgINDir = 'former\';
imgINName = 'main';
imgINExt = '.png';

imgOUTUnique = '';
imgOUTPath = [imgWorkPath 'out\' imgINDir];
imgTMPPath = [imgOUTPath '\tmp\'];
imgOUTExt = '.png';
imgOUTNumFormat = '%02d';
imgOUTSizeFormat = '%03d';
imgOUTSize = 128;
% 2.3
slices = 100;
sliceStep = 10;

dataFileName = 'data_';

0
mkdir([imgWorkPath 'out\']);
mkdir(imgOUTPath);
mkdir(imgTMPPath);
imgOUTSizeHalf = imgOUTSize/2;
1
testImage = imread([imgINPath imgINDir imgINName imgINExt]);
clear imgINPath imgINDir imgINName imgINExt imgWorkPath;
2
% 2.1
[~, S, V] = rgb2hsv(testImage);
[width, height] = size(V);
% 2.2
V = imadjust(V);
S = imadjust(S);
% Задаём информацию о фильтрах edge
methodS='Canny';
methodV='Canny';
imgOUTFilterS = ['filter_' methodS];
imgOUTFilterV = ['filter_' methodV];
% 2.4
win = gausswin(sliceStep)';
% Создаём файл логирования информации
dataFile = fopen( [imgOUTPath dataFileName imgOUTUnique '.txt'], 'w+');
fprintf(dataFile, ['Size: ' num2str(width) 'x' num2str(height) '\r\n']);
fprintf(dataFile, ['Slices: ' num2str(slices) '\r\n']);
fprintf(dataFile, ['Step: ' num2str(sliceStep) '\r\n']);
fprintf(dataFile, ['S: ' imgOUTFilterS '\r\n']);
fprintf(dataFile, ['V: ' imgOUTFilterV '\r\n']);
% 2.5
% Ищем динамический диапазон изображения
max_S = max(max(S));
min_S = min(min(S));
max_V = max(max(V));
min_V = min(min(V));

for index_0 = 1:slices/sliceStep
    clc;
    progress_2 = [index_0 slices/sliceStep]
    % Запоменаем текущие индексы слоёв
    start = (index_0 - 1) * sliceStep + 1; % 1 11 21 etc.
    back = start + sliceStep - 1; % 10 20 30 etc.
    
    % Выделяем/чистим память под акамуляторы
    S_bin_OUT = zeros(size(S));
    S_edg_OUT = zeros(size(S));
    V_bin_OUT = zeros(size(V));
    V_edg_OUT = zeros(size(V));
    
    index_1 = 1; % это лучше чем 4 раза писать "index_2 - start + 1"
    for index_2 = start:back
        % 2.5.1
        S_bin = imbinarize(S, (max_S - min_S) * index_2/slices + min_S);
        V_bin = imbinarize(V, (max_V - min_V) * index_2/slices + min_V);
        % 2.5.2 %OP = add
        S_bin_OUT = S_bin_OUT + win(index_1) * S_bin;
        S_edg_OUT = S_edg_OUT + win(index_1) * edge(S_bin, methodS);
        V_bin_OUT = V_bin_OUT + win(index_1) * V_bin;
        V_edg_OUT = V_edg_OUT + win(index_1) * edge(V_bin, methodV);
        index_1 = index_1 + 1;
    end
    % 2.5.3
    imgTMPCallInfo = num2str(index_0, imgOUTNumFormat);
    
    imwrite(mat2gray(S_bin_OUT), [imgTMPPath imgOUTUnique 'SB' imgTMPCallInfo imgOUTExt]);
    imwrite(mat2gray(S_edg_OUT), [imgTMPPath imgOUTUnique 'SE' imgTMPCallInfo imgOUTExt]);
    imwrite(mat2gray(V_bin_OUT), [imgTMPPath imgOUTUnique 'VB' imgTMPCallInfo imgOUTExt]);
    imwrite(mat2gray(V_edg_OUT), [imgTMPPath imgOUTUnique 'VE' imgTMPCallInfo imgOUTExt]);
end

clear S max_S min_S S_bin S_bin_OUT S_edg_OUT methodS imgOUTFilterS;
clear V max_V min_V V_bin V_bin_OUT V_edg_OUT methodV imgOUTFilterV;
clear win progress_2 start back testImage;

% к 3.1
widthPading = ceil(width / imgOUTSizeHalf) * imgOUTSizeHalf - width;
heightPading = ceil(height / imgOUTSizeHalf) * imgOUTSizeHalf - height;
fullWidth = width+widthPading;
fullHeight = height+heightPading;
fprintf(dataFile, ['Out size:' num2str(imgOUTSize) '\r\n']);
fprintf(dataFile, ['Full W:' num2str(fullWidth) '\r\n']);
fprintf(dataFile, ['Full H:' num2str(fullHeight) '\r\n']);
fprintf(dataFile, ['Subim W:' num2str(fullWidth/imgOUTSizeHalf - 1) '\r\n']);
fprintf(dataFile, ['Subim H:' num2str(fullHeight/imgOUTSizeHalf - 1) '\r\n']);
fclose(dataFile);
clear dataFile;

imgOUTPathSB = [imgOUTPath '\SB\'];
imgOUTPathSE = [imgOUTPath '\SE\'];
imgOUTPathVB = [imgOUTPath '\VB\'];
imgOUTPathVE = [imgOUTPath '\VE\'];

mkdir(imgOUTPathSB);
mkdir(imgOUTPathSE);
mkdir(imgOUTPathVB);
mkdir(imgOUTPathVE);

clear imgOUTPath dataFileName width height imgOUTSize;

3
for index_0 = 1:slices/sliceStep
    clc;
    progress_3 = [index_0 slices/sliceStep]
    imgTMPCallInfo = num2str(index_0, imgOUTNumFormat);
    stepOUTName = [imgOUTUnique imgTMPCallInfo];
    % Открываем по 4 изображения в TMP
    stepImgSB = imread([imgTMPPath imgOUTUnique 'SB' imgTMPCallInfo imgOUTExt]);
    stepImgSE = imread([imgTMPPath imgOUTUnique 'SE' imgTMPCallInfo imgOUTExt]);
    stepImgVB = imread([imgTMPPath imgOUTUnique 'VB' imgTMPCallInfo imgOUTExt]);
    stepImgVE = imread([imgTMPPath imgOUTUnique 'VE' imgTMPCallInfo imgOUTExt]);
    % 3.1
    stepImgSB = padarray(stepImgSB, [widthPading heightPading], 0, 'post');
    stepImgSE = padarray(stepImgSE, [widthPading heightPading], 0, 'post');
    stepImgVB = padarray(stepImgVB, [widthPading heightPading], 0, 'post');
    stepImgVE = padarray(stepImgVE, [widthPading heightPading], 0, 'post');
    
    mkdir([imgOUTPathSB '\' imgTMPCallInfo '\' ]);
    mkdir([imgOUTPathSE '\' imgTMPCallInfo '\' ]);
    mkdir([imgOUTPathVB '\' imgTMPCallInfo '\' ]);
    mkdir([imgOUTPathVE '\' imgTMPCallInfo '\' ]);
    
    for index_1 = 1:4
        switch index_1
            case 1 
                stepImage = stepImgSB;
                stepOUTPath = [imgOUTPathSB '\' imgTMPCallInfo '\' ];
            case 2 
                stepImage = stepImgSE;
                stepOUTPath = [imgOUTPathSE '\' imgTMPCallInfo '\' ];
            case 3 
                stepImage = stepImgVB;
                stepOUTPath = [imgOUTPathVB '\' imgTMPCallInfo '\' ];
            case 4 
                stepImage = stepImgVE;
                stepOUTPath = [imgOUTPathVE '\' imgTMPCallInfo '\' ];
        end
        for index_2 = 1:fullHeight/imgOUTSizeHalf - 1
            % Загружаем по строке widthX64
            tmpImage = stepImage(:, ((index_2 - 1) * imgOUTSizeHalf + 1):((index_2 + 1) * imgOUTSizeHalf));
            for index_3 = 1:fullWidth/imgOUTSizeHalf - 1
                imgOUTMetadata = ['W' num2str(index_3, imgOUTSizeFormat) 'H' num2str(index_2, imgOUTSizeFormat)];
                imwrite(tmpImage(((index_3 - 1) * imgOUTSizeHalf + 1):((index_3 + 1) * imgOUTSizeHalf), :), [stepOUTPath stepOUTName imgOUTMetadata imgOUTExt]);
            end
        end
    end
end

clear stepImgSB stepImgSE stepImgVB stepImgVE stepImage tmpImage;
clear imgOUTPathSB imgOUTPathSE imgOUTPathVB imgOUTPathVE imgTMPCallInfo imgOUTMetadata stepOUTName;
clear imgTMPPath imgOUTExt imgOUTSizeFormat imgOUTNumFormat imgOUTUnique stepOUTPath progress_3;
4
clear ans widthPading heightPading;
