% 012 VE only 
clear all
close all
clc

% ��������:
% 1 ��������� �������� �����������
% 2 ��������� � ��� 003
%     1 ������������� � V
%     2 imadjust
%     3 ������ ���������� ������� (slices) � ��� (sliceStep)
%     4 ������ ���� 1-D
%     5 ��� ���� slices/sliceStep �������:
%         1 �������������� �������� �� ����������� ������
%         2 OP � ����� ����������� � ������ � ������ �������� ����
%         3 ���������� ������ � TMP
% 3 ��� ������� ������:
%     1 ������ �� ��������� �� imgOUTSizeHalf
%     2 ��������� �� ��������� �� imgOUTSizeHalfXimgOUTSizeHalf
%     3 ������� ��������� � ��������� imgOUTSizeXimgOUTSize �� ����� ����������
%     4 ��������� ��������� �� ���� ����������

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
imgOUTSize = 64;
% 2.3
slices = 100;
sliceStep = 10;

dataFileName = 'data_';

disp(0);
mkdir([imgWorkPath 'out\']);
mkdir(imgOUTPath);
mkdir(imgTMPPath);
imgOUTSizeHalf = imgOUTSize/2;
disp(1);
testImage = imread([imgINPath imgINDir imgINName imgINExt]);
clear imgINPath imgINDir imgINName imgINExt imgWorkPath;
disp(2);
% 2.1
[~, ~, V] = rgb2hsv(testImage);
[width, height] = size(V);
% 2.2
V = imadjust(V);
% ����� ���������� � �������� edge
methodV='Canny';
imgOUTFilterV = ['filter_' methodV];
% 2.4
win = gausswin(sliceStep)';
% ������ ���� ����������� ����������
dataFile = fopen( [imgOUTPath dataFileName imgOUTUnique '.txt'], 'w+');
fprintf(dataFile, ['Size: ' num2str(width) 'x' num2str(height) '\r\n']);
fprintf(dataFile, ['Slices: ' num2str(slices) '\r\n']);
fprintf(dataFile, ['Step: ' num2str(sliceStep) '\r\n']);
fprintf(dataFile, ['V: ' imgOUTFilterV '\r\n']);
% 2.5
% ���� ������������ �������� �����������
max_V = max(max(V));
min_V = min(min(V));

for index_0 = 1:slices/sliceStep
    clc;
    progress_2 = [index_0 slices/sliceStep]
    % ���������� ������� ������� ����
    start = (index_0 - 1) * sliceStep + 1; % 1 11 21 etc.
    back = start + sliceStep - 1; % 10 20 30 etc.
    
    % ��������/������ ������ ��� �����������
    V_edg_OUT = zeros(size(V));
    
    index_1 = 1; % ��� ����� ��� 4 ���� ������ "index_2 - start + 1"
    for index_2 = start:back
        % 2.5.1
        V_bin = imbinarize(V, (max_V - min_V) * index_2/slices + min_V);
        % 2.5.2 %OP = add
        V_edg_OUT = V_edg_OUT + win(index_1) * edge(V_bin, methodV);
        index_1 = index_1 + 1;
    end
    % 2.5.3
    imgTMPCallInfo = num2str(index_0, imgOUTNumFormat);
    
    imwrite(mat2gray(V_edg_OUT), [imgTMPPath imgOUTUnique 'VE' imgTMPCallInfo imgOUTExt]);
end

clear V max_V min_V V_bin V_edg_OUT methodV imgOUTFilterV;
clear win progress_2 start back testImage;

% � 3.1
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

imgOUTPathVE = [imgOUTPath '\VE\'];

mkdir(imgOUTPathVE);

clear imgOUTPath dataFileName width height imgOUTSize;

disp(3);
for index_0 = 1:slices/sliceStep
    clc;
    progress_3 = [index_0 slices/sliceStep]
    imgTMPCallInfo = num2str(index_0, imgOUTNumFormat);
    stepOUTName = [imgOUTUnique imgTMPCallInfo];
    % ��������� ����������e � TMP
    stepImgVE = imread([imgTMPPath imgOUTUnique 'VE' imgTMPCallInfo imgOUTExt]);
    % 3.1
    stepImgVE = padarray(stepImgVE, [widthPading heightPading], 0, 'post');
    
    mkdir([imgOUTPathVE '\' imgTMPCallInfo '\' ]);
    
    stepImage = stepImgVE;
    stepOUTPath = [imgOUTPathVE '\' imgTMPCallInfo '\' ];
    for index_1 = 1:fullHeight/imgOUTSizeHalf - 1
        % ��������� �� ������ widthX64
        tmpImage = stepImage(:, ((index_1 - 1) * imgOUTSizeHalf + 1):((index_1 + 1) * imgOUTSizeHalf));
        for index_2 = 1:fullWidth/imgOUTSizeHalf - 1
            imgOUTMetadata = ['W' num2str(index_2, imgOUTSizeFormat) 'H' num2str(index_1, imgOUTSizeFormat)];
            imwrite(tmpImage(((index_2 - 1) * imgOUTSizeHalf + 1):((index_2 + 1) * imgOUTSizeHalf), :), [stepOUTPath stepOUTName imgOUTMetadata imgOUTExt]);
        end
    end
end

clear stepImgVE stepImage tmpImage;
clear imgOUTPathVE imgTMPCallInfo imgOUTMetadata stepOUTName;
clear imgTMPPath imgOUTExt imgOUTSizeFormat imgOUTNumFormat imgOUTUnique stepOUTPath progress_3;
disp(4);
clear ans widthPading heightPading;
