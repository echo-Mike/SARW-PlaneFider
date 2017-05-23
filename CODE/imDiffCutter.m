function imageArray = imDiffCutter(imgIN, baseLayerCount, layerCount)
    [W, H] = size(imgIN);
    imageArray = zeros(W, H, layerCount);
    
    slicesPerLayer = baseLayerCount/layerCount;
    
    for index_0 = 1:layerCount
        for index_1 = 1:slicesPerLayer
            buffImage = double(imbinarize(imgIN, ((index_0 - 1) * slicesPerLayer + index_1)/baseLayerCount));
            imageArray(:,:,index_0) = imageArray(:,:,index_0) + edge(buffImage, 'canny');
        end
    end
    return;
end