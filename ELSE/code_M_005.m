% PSNR SNR MSE
clear all
close all
clc

imgINPath = '.\pics\pic';
imgINDir = 'pic_test_006\';
imgINName = 'main';
imgINExt = '.png';

fileOUTPath = imgINPath;
fileOUTDir = imgINDir;
fileOUTName = 'psnr';
fileOUTExt = '.txt';
fileOUTid = fopen([fileOUTPath fileOUTDir fileOUTName fileOUTExt], 'w'); 

count = 4;
testImage = imread([imgINPath imgINDir imgINName imgINExt]);
testImage = rgb2gray(testImage);
testImageAdj = imadjust(testImage);

for index_ = 1:count 
    
    psnrImage = imread([imgINPath imgINDir 'psnr_' num2str(index_) imgINExt]);
    psnrImage = rgb2gray(psnrImage);
    psnrImageAdj = imadjust(psnrImage);
    
    [~,snr] = psnr(testImage, psnrImage);
    mse = immse(testImage, psnrImage);
    fprintf(fileOUTid, ['NON: Snr: %1$10.4f; Mse: %2$10.4f; Name: psnr_' num2str(index_) '\r\n'], snr, mse);
    
    [~,snr] = psnr(testImageAdj, psnrImageAdj);
    mse = immse(testImageAdj, psnrImageAdj);
    fprintf(fileOUTid, ['ADJ: Snr: %1$10.4f; Mse: %2$10.4f; Name: psnr_' num2str(index_) '\r\n'], snr, mse);
end
fprintf('DONE\n');
fclose(fileOUTid);

