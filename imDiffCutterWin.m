function imageArray = imDiffCutterWin(imgIN, baseLayerCount, layerCount, Win)
    [W, H] = size(imgIN);
    imageArray = zeros(W, H, layerCount);
    
    slicesPerLayer = baseLayerCount/layerCount;
    if slicesPerLayer ~= size(Win, 1)
        disp('Error::imDiffCutterWin::Size of Window and slicesPerLayer do not mutch.');
        imageArray = false;
        return;
    end
    for index_0 = 1:layerCount
        for index_1 = 1:slicesPerLayer
            buffImage = double(imbinarize(imgIN, ((index_0 - 1) * slicesPerLayer + index_1)/baseLayerCount));
            imageArray(:,:,index_0) = imageArray(:,:,index_0) + Win(index_1) * edge(buffImage, 'canny');
        end
    end
    return;
end