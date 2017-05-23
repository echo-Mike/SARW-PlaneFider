% Видосы крутящейся картинки для \pics\rotator\
clear all
close all
clc

imgINPath = '.\pics\rotator\';
imgINDir = 'pair_test_001\';
imgINName = 'main';
imgINExt = '.png';

vidOUTUnique = '';
vidOUTDir = 'out\';
vidOUTPath = [imgINPath imgINDir vidOUTDir];
vidOUTName = [vidOUTPath 'out_' vidOUTUnique];
vidOUTExt = '.avi';

vidOUTmap = jet(256);

testImage = imread([imgINPath imgINDir imgINName imgINExt]);
% testImage = rgb2gray(testImage);

steps = 15*10;
stepSize = 360/(steps+1);

vidOUTAviIMG = VideoWriter([vidOUTName 'image' vidOUTExt], 'Uncompressed AVI');
vidOUTAviHOU = VideoWriter([vidOUTName 'hough' vidOUTExt], 'Uncompressed AVI');
vidOUTAviFFT = VideoWriter([vidOUTName 'fft' vidOUTExt], 'Uncompressed AVI');
vidOUTAviHFF = VideoWriter([vidOUTName 'hfft' vidOUTExt], 'Uncompressed AVI');

open(vidOUTAviIMG);
open(vidOUTAviHOU);
open(vidOUTAviFFT);
open(vidOUTAviHFF);

for index_ = 0:stepSize:360-stepSize
    if index_ ~= 0
        stepImage = imrotate(testImage, index_, 'bicubic', 'crop');
    else 
        stepImage = testImage;
    end
    stepHough = hough(stepImage);
    stepHoughFft = fft2(stepHough);
    stepFft = fft2(stepImage);
    
    stepImage =     imadjust(mat2gray(stepImage));
    stepHough =     imadjust(mat2gray(stepHough));
    stepHoughFft =  imadjust(mat2gray(abs(fftshift(stepHoughFft))));
    stepFft =       imadjust(mat2gray(abs(fftshift(stepFft))));
    
    stepImage =     ind2rgb(uint8(256 * stepImage), vidOUTmap);
    stepHough =     ind2rgb(uint8(256 * stepHough), vidOUTmap);
    stepHoughFft =  ind2rgb(uint8(256 * stepHoughFft), vidOUTmap);
    stepFft =       ind2rgb(uint8(256 * stepFft), vidOUTmap);

    writeVideo(vidOUTAviIMG, stepImage);
    writeVideo(vidOUTAviHOU, stepHough);
    writeVideo(vidOUTAviHFF, stepHoughFft);
    writeVideo(vidOUTAviFFT, stepFft);
end

close(vidOUTAviIMG);
close(vidOUTAviHOU);
close(vidOUTAviFFT);
close(vidOUTAviHFF);

clear all
close all
clc
