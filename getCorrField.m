function [maxField, minField, meanField] = getCorrField(INimg, INtemplate, directionsCount)
%     [width, height] = size(INimg);
    % —делать шаблон квадратным дл€ того чтобы размеры получающихс€ при
    % коррел€ции матриц совпадали.
    [tW, tH] = size(INtemplate);
    if tW > tH
        templ = padarray(INtemplate, [0, ceil((tW - tH)/2)]);
    elseif tW < tH
        templ = padarray(INtemplate, [ceil((tH - tW)/2), 0]);
    else
        templ = INtemplate;
    end
%     [tW, tH] = size(templ);
%     W = width + tW - 1;
%     H = height + tH - 1;
%     
%     maxField = zeros(W, H);
%     minField = zeros(W, H);
%     meanField = zeros(W, H);
    
    angleStep = 360 / directionsCount;
    buffer = xcorr2(INimg, templ);
    maxField = buffer;
    minField = buffer;
    meanField = buffer;
    
    for index_0 = 1:directionsCount-1
        buffer = xcorr2(INimg, imrotate(templ, angleStep * index_0, 'crop', 'bicubic'));
        maxField = max(maxField, buffer);
        minField = min(minField, buffer);
        meanField = meanField + buffer;
    end
    meanField = meanField / directionsCount;
    
    return;
end