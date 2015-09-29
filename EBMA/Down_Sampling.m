function [ DownFrame ] = Down_Sampling( originFrame )
% Downsampling an interpolated frame. 
% In this case, DownSampling factor is 2.

[M, N] = size(originFrame);

% Shrink the image by factor 2
M = M/2;
N = N/2;
DownFrame = zeros(M, N);

% Only save half of the pixels to the New Frame.
% In a bilinear manner same as interpolation.

for i=1:M
    for j=1:N
        if i == 1 && j == 1
            DownFrame(i, j) = originFrame(2*i-1, 2*j-1)+...
                (originFrame(2*i-1, 2*j)+...
                originFrame(2*i, 2*j-1))/2;
        elseif i == 1
            DownFrame(i, j) = originFrame(2*i-1, 2*j-1)+...
                (originFrame(2*i-1, 2*j-2)+...
                originFrame(2*i-1, 2*j)+...
                originFrame(2*i, 2*j-1))/3;
        elseif j == 1
            DownFrame(i, j) = originFrame(2*i-1, 2*j-1)+...
                (originFrame(2*i-2, 2*j-1)+...
                originFrame(2*i-1, 2*j)+...
                originFrame(2*i, 2*j-1))/3;
        else
            DownFrame(i, j) = originFrame(2*i-1, 2*j-1)+...
                (originFrame(2*i-2, 2*j-1)+...
                originFrame(2*i, 2*j-1)+...
                originFrame(2*i-1, 2*j-2)+...
                originFrame(2*i-1, 2*j))/4;
        end
    end
end

DownFrame = DownFrame/2;

end

