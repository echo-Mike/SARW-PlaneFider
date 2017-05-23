function result = findMainLines(INimg, linesCount)
    [H,T,~] = hough(edge(INimg, 'canny'));
    result = houghpeaks(H,linesCount);
    result = T(result(:,2));
    return;
end