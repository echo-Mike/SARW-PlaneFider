% Slice image for bin, edg for S and V
clear all
close all
clc

imgINPath = '.\pics\';
imgINDir = 'pic_test_000\';
imgINName = 'main';
imgINExt = '.png';

imgOUTUnique = 'plus_';
imgOUTPath = [imgINPath imgINDir];
imgOUTName = ['out_' imgOUTUnique];
imgOUTExt = '.png';

testImage = imread([imgINPath imgINDir imgINName imgINExt]);
[H, S, V] = rgb2hsv(testImage);

buff = S;

% S = V;
V = imadjust(V);
S = imadjust(S);

% figure();
% colorbar;
% subplot(1,2,1);
% imagesc(S);
% subplot(1,2,2);
% imagesc(V);
% colormap('jet');

methodS='Canny';
methodV='Canny';
slices = 100;
start = 90;
back = 100;
max_S = max(max(S));
min_S = min(min(S));
max_V = max(max(V));
min_V = min(min(V));
S_bin_OUT = ones(size(S));
S_edg_OUT = ones(size(S));
V_bin_OUT = ones(size(V));
V_edg_OUT = ones(size(V));

for index_ = start:back 
    S_bin = imbinarize(S, (max_S - min_S) * index_/slices + min_S);
    V_bin = imbinarize(V, (max_V - min_V) * index_/slices + min_V);
    S_bin_OUT = S_bin_OUT + S_bin;
    S_edg_OUT = S_edg_OUT + edge(S_bin, methodS);
    V_bin_OUT = V_bin_OUT + V_bin;
    V_edg_OUT = V_edg_OUT + edge(V_bin, methodV);
end

% figure();
% imagesc(S_bin_OUT);
% colormap('gray');
% 
% figure();
% imagesc(S_edg_OUT);
% colormap('gray');
% 
% figure();
% imagesc(V_bin_OUT);
% colormap('gray');
% 
% figure();
% imagesc(V_edg_OUT);
% colormap('gray');

imgOUTFilterS = ['filter_' methodS];
imgOUTFilterV = ['filter_' methodV];
imgOUTParts = ['sl_' num2str(slices) '_st_' num2str(start) '_ba_' num2str(back)];
imgOUTDataS = [imgOUTFilterS '_' imgOUTParts];
imgOUTDataV = [imgOUTFilterV '_' imgOUTParts];

% imwrite(S_bin_OUT, [imgOUTPath imgOUTName 'S_BIN_glued_' imgOUTDataS imgOUTExt]);
% imwrite(S_edg_OUT, [imgOUTPath imgOUTName 'S_EDG_glued_' imgOUTDataS imgOUTExt]);
% imwrite(V_bin_OUT, [imgOUTPath imgOUTName 'V_BIN_glued_' imgOUTDataV imgOUTExt]);
% imwrite(V_edg_OUT, [imgOUTPath imgOUTName 'V_EDG_glued_' imgOUTDataV imgOUTExt]);
imwrite(mat2gray(S_bin_OUT), [imgOUTPath imgOUTName 'S_BIN_glued_adj_' imgOUTDataS imgOUTExt]);
imwrite(mat2gray(S_edg_OUT), [imgOUTPath imgOUTName 'S_EDG_glued_adj_' imgOUTDataS imgOUTExt]);
imwrite(mat2gray(V_bin_OUT), [imgOUTPath imgOUTName 'V_BIN_glued_adj_' imgOUTDataV imgOUTExt]);
imwrite(mat2gray(V_edg_OUT), [imgOUTPath imgOUTName 'V_EDG_glued_adj_' imgOUTDataV imgOUTExt]);

% figure;
% subplot(1,2,1);
% imagesc(hsv2rgb(H, mat2gray(S_bin_OUT), mat2gray(V_bin_OUT)));
% subplot(1,2,2);
% imagesc(testImage);
% imwrite(mat2gray(hsv2rgb(H, mat2gray(S_bin_OUT), mat2gray(V_bin_OUT))), [imgINPath imgINName '_adv' imgOUTExt]);

