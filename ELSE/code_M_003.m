% Создаём варианты изображения по слойно с окном
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
% 2 Преобразовать в S и V
% 3 imadjust оба
% 4 задать количество делений (slices) и шаг (sliceStep)
% 5 задать окно 1-D
% 6 для всех slices/sliceStep выборок:
%     1 бинаризировать исходное по скользящему порогу
%     2 OP с окном акамулируем в буфере и делаем детекцию краёв
%     3 Записываем на диск

imgWorkPath = '.\pics\pic\pic_test_001\';

imgINPath = [imgWorkPath 'in\'];
imgINDir = 'generator\';
imgINName = 'main';
imgINExt = '.png';

imgOUTUnique = '';
imgOUTPath = [imgWorkPath 'out\' imgINDir];
imgOUTExt = '.png';
imgOUTNumFormat = '%02d';
imgOUTSizeFormat = '%03d';

slices = 100;
sliceStep = 10;

dataFileName = 'zzz_data_';

mkdir([imgWorkPath 'out\']);
mkdir(imgOUTPath);

testImage = imread([imgINPath imgINDir imgINName imgINExt]);
clear imgINPath imgINDir imgINName imgINExt imgWorkPath;

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
fprintf(dataFile, ['Slices: ' num2str(slices) '\r\n']);
fprintf(dataFile, ['Step: ' num2str(sliceStep) '\r\n']);
fprintf(dataFile, ['S: ' imgOUTFilterS '\r\n']);
fprintf(dataFile, ['V: ' imgOUTFilterV '\r\n']);
fclose(dataFile);
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
    
    imwrite(mat2gray(S_bin_OUT), [imgOUTPath imgOUTUnique 'SABG' imgTMPCallInfo imgOUTExt]);
    imwrite(mat2gray(S_edg_OUT), [imgOUTPath imgOUTUnique 'SAEG' imgTMPCallInfo imgOUTExt]);
    imwrite(mat2gray(V_bin_OUT), [imgOUTPath imgOUTUnique 'VABG' imgTMPCallInfo imgOUTExt]);
    imwrite(mat2gray(V_edg_OUT), [imgOUTPath imgOUTUnique 'VAEG' imgTMPCallInfo imgOUTExt]);
end

clear S max_S min_S S_bin S_bin_OUT S_edg_OUT methodS imgOUTFilterS;
clear V max_V min_V V_bin V_bin_OUT V_edg_OUT methodV imgOUTFilterV;
clear win progress_2 start back testImage;
clear all;
close all;