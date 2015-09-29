function [ PSNR ] = PSNR( targetImg, originImg )
% This Function will compute and return the PSNR between a target picture
% and the input original picture.

if (size(targetImg) ~= size(originImg))
    PSNR = 'Invalid Inputs';
    return;
end

if (targetImg == originImg)
    PSNR = 0;
    return;
end

[height,width] = size(originImg);

PSNR = 0;
for i = 1:height
    for j = 1:width
        PSNR = PSNR+(double(originImg(i, j))-double(targetImg(i, j)))^2;
    end
end

% This is MSE
PSNR = PSNR/(height*width);
% Compute the PSNR
PSNR = 10*log10((255^2)/PSNR);

end

