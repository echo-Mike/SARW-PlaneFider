function resultImage = imAddByCoord(firstImage, secondImage, X, Y) 
    % firstImage image to add
    % secondImage image to ad to
    % center of first image aligned with [X Y]
    [FIW, FIH] = size(firstImage);
    FICenterX = ceil(FIW/2);
    FICentarY = ceil(FIH/2);
    [SIW, SIH] = size(secondImage);
    if (X < FICenterX || X > SIW - FICenterX) || (Y < FICentarY || Y > SIH - FICentarY)
        disp('Error::imAddByCoord::Invalid coords, returning secondImage');
        resultImage = secondImage;
        return;
    end
    left = X - FICenterX + 1;
    right = X + FIW - FICenterX;
    bot = Y - FICentarY + 1;
    top = Y + FIH - FICentarY;
    resultImage = secondImage;
    resultImage(left:right, bot:top) = secondImage(left:right, bot:top) + firstImage;
end