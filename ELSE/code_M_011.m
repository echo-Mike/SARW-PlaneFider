% Plane collection
clear all
close all
clc

imgINPath1 = '.\pics\outlines\outlines_filled\in\';
imgINPath2 = '.\pics\outlines\outlines_norm\in\';
imgINDir = 'fft\';
imgINName = '';
imgINExt = '.png';

imgOUTUnique = '';
imgOUTPath = ['.\pics\outlines\out\' imgINDir];
mkdir(imgOUTPath);
imgOUTName = ['out_' imgOUTUnique];
imgOUTExt = '.png';

color = colormap('jet');

for index_ = 1:24 
%  Filled
   stepImage = imread([imgINPath1 imgINDir 'a (' num2str(index_) ')' imgINExt]);
   fftStep = fftshift(fft2(stepImage));
   stepHough = mat2gray(hough(stepImage));
   
   imwrite(256*mat2gray(angle(fftStep)), color, [imgOUTPath imgOUTName 'F_pha_' num2str(index_) imgOUTExt]);
   imwrite(256*mat2gray(abs(fftStep)), color, [imgOUTPath imgOUTName 'F_abs_' num2str(index_) imgOUTExt]);
   imwrite(256 * stepHough, color, [imgOUTPath imgOUTName 'F_hou_' num2str(index_) imgOUTExt]);
   
%  Edges
   stepImage = imread([imgINPath2 imgINDir 'a (' num2str(index_) ')' imgINExt]);
   fftStep = fftshift(fft2(stepImage));
   stepHough = mat2gray(hough(stepImage));
   
   imwrite(256*mat2gray(angle(fftStep)), color, [imgOUTPath imgOUTName 'E_pha_' num2str(index_) imgOUTExt]);
   imwrite(256*mat2gray(abs(fftStep)), color, [imgOUTPath imgOUTName 'E_abs_' num2str(index_) imgOUTExt]);
   imwrite(256 * stepHough, color, [imgOUTPath imgOUTName 'E_hou_' num2str(index_) imgOUTExt]);
end