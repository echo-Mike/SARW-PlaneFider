function OUTimg = createArialImage(INimgArray, winSize, criterion, gausFilterSize, cutThreshold)
    [width, height, count] = size(INimgArray);
    OUTimg = zeros(width, height);
    stepImage = zeros(width, height, winSize);
    for index_0 = 1:count-winSize+1
        for index_1 = 1:winSize
            stepImage(:,:,index_1) = imbinarize(imgaussfilt(double(INimgArray(:,:,index_0+index_1-1)), gausFilterSize), cutThreshold);
        end
        for index_1 = 1:winSize - criterion + 1
            stepBuffer = double(stepImage(:,:,index_1));
            for index_2 = 1:criterion-1
                stepBuffer = stepBuffer .* double(stepImage(:,:,index_1+index_2));
            end
            OUTimg = OUTimg + stepBuffer;
        end
    end
    return;
end