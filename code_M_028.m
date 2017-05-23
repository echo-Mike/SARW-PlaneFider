% ��������� ���������
clear all
close all
clc

imgWorkPath = '.\pics\pic\pic_test_001\';

imgINMainName = 'main';
imgINTemplateName = 'template';
imgINExt = '.png';
% ������ ������� �� ���� �� ������ � ��������
% ����� ������ �������� : [1 2 3]
planeSize = 74;
% ������ ����������� ������ ������� (� ������ �������)
% ����� ������ �������� : [1 2 3]
paddingSize = 10;
% ������� ������ �������� �� ��������
planesEstimatedCount = 3;
% ���������� ����������� ��������, � ������� ���������� ������ 8 ��� 16 �
% ������.
analyzedDirectionsCount = 8;

imgOUTUnique = '';
imgOUTPath = [imgWorkPath 'out\'];
imgOUTExt = '.png';

imgOUTNumFormat = '%03d';

disp('0) Loading images')
% ������ ����� ��� �������� �����������
mkdir(imgOUTPath);

% ��������� ����������� � �����
testImage = imread([imgWorkPath imgINMainName imgINExt]);
% testImage = double(testImage);
% ������� ������� ��������� �����������
[mainImgWidth, mainImgHeight, ~] = size(testImage);

% ��������� ������ ������ � �����
testTemplate = imread([imgWorkPath imgINTemplateName imgINExt]);
% rgb2gray
testTemplate = double((testTemplate));

% ����������� �������� ����������� � hsv �����
[H, S, V] = rgb2hsv(testImage);

disp('1) Finding main lines')
% ������� ���� �������� �������� ����� �����������
mainLines = findMainLines(imadjust(rgb2gray(testImage)), 5);
% ������� : ������� ���� �������� ����� �� ������������ �� ������ ���� ��������.
mainLine = min(1i * mainLines) / 1i;
if mod(mainLine, 360/analyzedDirectionsCount) == 0
    mainLine = 0;
end
clear mainLines;

disp('2) Creating masks')
% �������� ����� �� ������� � �������������
% ������ �����-�������� : 10
% ���������� ������� ���� : 99
% ���������� ����� : 3
% ����� ����������� : 0.1
hMasksImgArray = createMasks(H, 10, 99, 3, 0.1);
sMasksImgArray = createMasks(S, 10, 99, 3, 0.1);
masksImgArray = cat(3, hMasksImgArray, sMasksImgArray);
clear hMasksImgArray sMasksImgArray;

disp('3) Taking binarized differentials')
% ����� ���� ��� ������ �����������
% ���������� ������� ���� : 100
% ���������� ���������� ���� : 10
win = gausswin(100/10);
% ���� ���������������� ����������� ��� ������� � �������������
vDiffImgArray = imDiffCutterWin(V, 100, 10, win);
sDiffImgArray = imDiffCutterWin(S, 100, 10, win);
clear H S V win;

disp('4) Creatimg search arrays')
% �������� ����������� ����������� � ����������� �������� 
% � ������������� ����, � ���������� ���������.
% ��� �������� : 2 �� 3 � 3 �� 5 - 3 �� 5 ����� ������ �������� ��� 2 �� 3
criterion = [3, 2; 5, 3;];
% criterion = [5, 3];
% ��� �������� : 5 - ������� �������, 3 - �������, 1 -��������� - ��
% ��������� � �������� � ���������� ��������.
gaussFilterSizes = [5, 3, 1];
% gaussFilterSizes = 1;

disp(4.1)
% ������� ��� ��������� ������
vSearchImgArray = zeros(mainImgWidth, mainImgHeight, size(criterion,1) * size(gaussFilterSizes,2));
for index_0 = 1:size(criterion,1)
    for index_1 = 1:size(gaussFilterSizes,2)
        vSearchImgArray(:,:,(index_0-1)*3+index_1) = createArialImage(vDiffImgArray, criterion(index_0, 1), criterion(index_0, 2), gaussFilterSizes(index_1), 0.1);
    end
end
disp(4.2)
% ����� ��� �������������
sSearchImgArray = zeros(mainImgWidth, mainImgHeight, size(criterion,1) * size(gaussFilterSizes,2));
for index_0 = 1:size(criterion,1)
    for index_1 = 1:size(gaussFilterSizes,2)
        sSearchImgArray(:,:,(index_0-1)*3+index_1) = createArialImage(sDiffImgArray, criterion(index_0, 1), criterion(index_0, 2), gaussFilterSizes(index_1), 0.1);
    end
end
% ��������� ������
clear vDiffImgArray sDiffImgArray;

disp('5) Rotating images')
% ������������ ����������� �����������
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
% ���������� ��������� ����� ��������� ����� ���������� �������� �������
% ��������
stepsCount = max(size(planeSize));
% ��������� ��������
% 6 - ���������� ����������� � SearchImgArray'�� 
% 3 - ���������� ����� ��� ������� ������
for index_0 = 1:stepsCount
    stepTemplate = imresize(testTemplate, planeSize(index_0)/size(testTemplate, 1));
    
    % ��� ������ ����� ��������� �����
    for index_1 = 1:size(RmasksImgArray, 3)
        
        disp([num2str(index_0) ') VFP: ' codeNames(index_1,:)])
        uniqeName = [imgOUTUnique 'VS' codeNames(index_1,:) num2str(planeSize(index_0))];
        % ��� ��������� ������
        vResultTable = imFindPlanes(RvSearchArray, stepTemplate, RmasksImgArray(:,:,index_1), analyzedDirectionsCount, planesEstimatedCount, imgOUTPath, uniqeName);
        
        disp([num2str(index_0) ') VCP: ' codeNames(index_1,:)])
        % �������� ���������� �������
        vResultImage = imCutPlanes(RtestImage, vResultTable, planesEstimatedCount, planeSize(index_0), paddingSize(index_0), imgOUTPath, uniqeName);
        
        % ��������� ���������� ����� ������������� �����������
        imwrite(255*mat2gray(vResultImage), jet(256), [imgOUTPath imgOUTUnique codeNames(index_1,:) 'VEstimationN' num2str(index_0,imgOUTNumFormat) imgOUTExt]);
        
        % �������� ������� ����������� � ���� �� ��������
        logFile = fopen([imgOUTPath imgOUTUnique 'Vlog' num2str(index_0,imgOUTNumFormat) codeNames(index_1,:) '.txt'],'w+');
        for index_2 = 1:size(vResultTable, 1)
            fprintf(logFile, [num2str(vResultTable(index_2,1)) '\t' num2str(vResultTable(index_2,2)) '\t' num2str(vResultTable(index_2,1)) '\r\n']);
        end
        fclose(logFile);
        
        disp([num2str(index_0) ') SFP: ' codeNames(index_1,:)])
        uniqeName = [imgOUTUnique 'SS' codeNames(index_1,:) num2str(planeSize(index_0))];
        % ��� �������������
        sResultTable = imFindPlanes(RsSearchArray, stepTemplate, RmasksImgArray(:,:,index_1), analyzedDirectionsCount, planesEstimatedCount, imgOUTPath, uniqeName);
        
        disp([num2str(index_0) ') SCP: ' codeNames(index_1,:)])
        % �������� ���������� �������
        sResultImage = imCutPlanes(RtestImage, sResultTable, planesEstimatedCount, planeSize(index_0), paddingSize(index_0), imgOUTPath, uniqeName);
        
        % ��������� ���������� ����� ������������� �����������
        imwrite(255*mat2gray(sResultImage), jet(256), [imgOUTPath imgOUTUnique codeNames(index_1,:) 'SEstimationN' num2str(index_0,imgOUTNumFormat) imgOUTExt]);
        
        % �������� ������� ����������� � ���� �� ��������
        logFile = fopen([imgOUTPath imgOUTUnique 'Slog' num2str(index_0,imgOUTNumFormat) codeNames(index_1,:) '.txt'],'w+');
        for index_2 = 1:size(vResultTable, 1)
            fprintf(logFile, [num2str(vResultTable(index_2,1)) '\t' num2str(vResultTable(index_2,2)) '\t' num2str(vResultTable(index_2,1)) '\r\n']);
        end
        fclose(logFile);
    end
end
