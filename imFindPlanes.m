function resultTable = imFindPlanes(SearchArray, Template, MaskArray, dirCount, planesEstimatedCount, savePath, uniqeName)
    resultTable = [0,0,0];
    searchSize = size(SearchArray, 3);
    maskSize = size(MaskArray, 3);
    color = jet(256);
    for index_0 = 1:searchSize
        for index_1 = 1:maskSize
            stepImage = SearchArray(:,:,index_0) .* MaskArray(:,:,index_1);
            imgOUTName = [savePath uniqeName 'SA' num2str(index_0) 'M' num2str(index_1) '.png'];
            imwrite(255*mat2gray(stepImage), color, imgOUTName);
            [maxF, ~, meanF] = getCorrField(stepImage, Template, dirCount);
            maxF = maxF - meanF;
            P = houghpeaks(floor(maxF), planesEstimatedCount); %'floor' Это свойство функции может быть проблемой
            buffTable = zeros(size(P,1),3);
            for index_2 = 1:size(P,1)
                buffTable(index_2,:) = [P(index_2,2), P(index_2,1), maxF(P(index_2,1), P(index_2,2))];
            end
            resultTable = cat(1, resultTable, buffTable);
        end
    end
    return;
end