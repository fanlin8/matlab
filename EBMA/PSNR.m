function [ PSNR ] = PSNR( predictFrame, anchorFrame )
% This Function will compute and return the PSNR between a predict frame
% and a reference frame.

[height,width] = size(anchorFrame);

PSNR = 0;
for i = 1:height
    for j = 1:width
        PSNR = PSNR+(double(anchorFrame(i, j))-double(predictFrame(i, j)))^2;
    end
end

% This is MSE
PSNR = PSNR/(height*width);
% Compute the PSNR
PSNR = 10*log10((255^2)/PSNR);

end
