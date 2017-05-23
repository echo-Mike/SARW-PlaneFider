function imgOUTArray = createMasks(INimg, gausFilterSize, baseLayersCount, maskCount, cutThreshold)
    buffImage = double(imadjust(mat2gray(imgaussfilt(INimg, gausFilterSize))));
    imgOUTArray = imDiffCutter(buffImage, baseLayersCount, maskCount);
    for index_0 = 1:maskCount
        imgOUTArray(:,:,index_0) = imgaussfilt(imgOUTArray(:,:,index_0), gausFilterSize);
        imgOUTArray(:,:,index_0) = imadjust(imgOUTArray(:,:,index_0));
        imgOUTArray(:,:,index_0) = imbinarize(imgOUTArray(:,:,index_0), cutThreshold);
        imgOUTArray(:,:,index_0) = double(imgOUTArray(:,:,index_0));
    end
    return;
end