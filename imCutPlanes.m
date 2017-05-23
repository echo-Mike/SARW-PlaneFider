function pImage = imCutPlanes(INimg, dataTable, planesCount, planesSize, paddingSize, savePath, uniqeName)
%     dataTable(:, 3) = 10*log10(dataTable(:, 3));
    tableMax = max(dataTable(:, 3));
    gaussPossibility = mat2gray(fspecial('gaussian', floor(planesSize/2), planesSize/10));
    [W, H, ~] = size(INimg);
    bufferImage = padarray(zeros(W,H),  ceil([planesSize/2, planesSize/2]) + paddingSize + 15);
    [W, H] = size(bufferImage);
    overSizedR = double(padarray(INimg(:,:,1), ceil([planesSize/2, planesSize/2]) + paddingSize + 15));
    overSizedG = double(padarray(INimg(:,:,2), ceil([planesSize/2, planesSize/2]) + paddingSize + 15));
    overSizedB = double(padarray(INimg(:,:,3), ceil([planesSize/2, planesSize/2]) + paddingSize + 15));
    for index_0 = 1:size(dataTable, 1)
        bufferImage = imAddByCoord(dataTable(index_0, 3)/tableMax * gaussPossibility, bufferImage, dataTable(index_0, 2), dataTable(index_0, 1));
    end
    imwrite(uint8(cat(3, overSizedR, overSizedG, overSizedB)), [savePath uniqeName 'OverSized.png']);
    P = houghpeaks(ceil(1024*bufferImage), planesCount);
    logFile = fopen([savePath uniqeName 'mainLog.txt'], 'w+');
    for index_0 = 1:size(P,1)
        fprintf(logFile, [num2str(P(index_0,1)) '\t' num2str(P(index_0,2)) '\t' num2str(bufferImage(P(index_0,1),P(index_0,2))) '\r\n']);
    end
    fclose(logFile);
    pImage = bufferImage;
    for index_0 = 1:size(P,1)
        left = clamp(P(index_0, 1)  - ceil(planesSize/2) - paddingSize, 1,W);
        right = clamp(P(index_0, 1) + (planesSize - ceil(planesSize/2)) + paddingSize, 1,W);
        top = clamp(P(index_0, 2)   + (planesSize - ceil(planesSize/2)) + paddingSize, 1,H);
        bot = clamp(P(index_0, 2)   - ceil(planesSize/2) - paddingSize, 1,H);
        bufferImageR = overSizedR(left:right,bot:top);
        bufferImageG = overSizedG(left:right,bot:top);
        bufferImageB = overSizedB(left:right,bot:top);
        imwrite(uint8(cat(3, bufferImageR, bufferImageG, bufferImageB)), [savePath uniqeName num2str(index_0, '%05d') '.png']);
    end
    return;
end